provider "azurerm" {
  features {}
}

locals {
  environment = "prod"
  location    = "eastus2"
  tags = {
    Environment = local.environment
    Project     = var.project_name
    Owner       = var.owner
    ManagedBy   = "Terraform"
    CostCenter  = var.cost_center
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${local.environment}-${local.location}"
  location = local.location
  tags     = local.tags
}

# Create a storage account with redundancy for production
resource "azurerm_storage_account" "app_storage" {
  name                     = "st${var.project_name}${local.environment}${local.location}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"  # Geo-redundant storage for production
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    delete_retention_policy {
      days = 30
    }
    container_delete_retention_policy {
      days = 30
    }
    versioning_enabled = true
  }
  
  tags = local.tags
}

resource "azurerm_storage_container" "app_data" {
  name                  = "appdata"
  storage_account_name  = azurerm_storage_account.app_storage.name
  container_access_type = "private"
}

# Use the same VNET module but with production configuration
module "network" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-${var.project_name}-${local.environment}-${local.location}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
  
  # More restrictive subnets for production
  subnets = {
    "web-subnet" = {
      address_prefix    = "10.0.1.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      create_nsg        = true
      nsg_rules         = [
        {
          name                       = "allow-https"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    },
    "app-subnet" = {
      address_prefix    = "10.0.2.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      create_nsg        = true
      nsg_rules         = [
        {
          name                       = "allow-web"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "8080"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
        }
      ]
    },
    "db-subnet" = {
      address_prefix    = "10.0.3.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      create_nsg        = true
      nsg_rules         = [
        {
          name                       = "allow-sql"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "1433"
          source_address_prefix      = "10.0.2.0/24"
          destination_address_prefix = "*"
        }
      ]
    },
    "management-subnet" = {
      address_prefix    = "10.0.4.0/24"
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      create_nsg        = true
      nsg_rules         = [
        {
          name                       = "allow-ssh"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = var.admin_cidr_blocks
          destination_address_prefix = "*"
        }
      ]
    }
  }
  
  # Enable network monitoring in production
  enable_network_monitoring           = true
  network_watcher_name                = "NetworkWatcher_${local.location}"
  network_watcher_resource_group_name = "NetworkWatcherRG"
  flow_logs_storage_account_id        = var.flow_logs_storage_account_id
  flow_logs_retention_days            = 30
  
  tags = local.tags
}

# Add an application gateway for production
resource "azurerm_public_ip" "appgw_pip" {
  name                = "pip-appgw-${var.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_application_gateway" "main" {
  name                = "appgw-${var.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = module.network.subnet_ids["web-subnet"]
  }

  frontend_port {
    name = "https-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name = "backend-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 8080
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "https-listener"
    frontend_ip_configuration_name = "frontend-ip-configuration"
    frontend_port_name             = "https-port"
    protocol                       = "Https"
    ssl_certificate_name           = "ssl-cert"
  }

  ssl_certificate {
    name     = "ssl-cert"
    data     = var.ssl_certificate_data
    password = var.ssl_certificate_password
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "https-listener"
    backend_address_pool_name  = "backend-pool"
    backend_http_settings_name = "http-settings"
    priority                   = 100
  }

  waf_configuration {
    enabled                  = true
    firewall_mode            = "Prevention"
    rule_set_type            = "OWASP"
    rule_set_version         = "3.2"
    file_upload_limit_mb     = 100
    request_body_check       = true
    max_request_body_size_kb = 128
  }

  tags = local.tags
}

# Add a Key Vault for secrets management
resource "azurerm_key_vault" "main" {
  name                     = "kv-${var.project_name}-${local.environment}"
  location                 = azurerm_resource_group.main.location
  resource_group_name      = azurerm_resource_group.main.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90
  purge_protection_enabled = true
  sku_name                 = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [var.admin_cidr_blocks]
    virtual_network_subnet_ids = [
      module.network.subnet_ids["app-subnet"],
      module.network.subnet_ids["management-subnet"]
    ]
  }

  tags = local.tags
}

data "azurerm_client_config" "current" {}