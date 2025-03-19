provider "azurerm" {
  features {}
  # Skip subscription_id for plan generation
  skip_provider_registration = true
}

locals {
  environment = "dev"
  location    = "eastus"
  tags = {
    Environment = local.environment
    Project     = var.project_name
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${local.environment}-${local.location}"
  location = local.location
  tags     = local.tags
}

# Create a storage account for application data
resource "azurerm_storage_account" "app_storage" {
  name                     = "st${var.project_name}${local.environment}${local.location}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  
  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
  }
  
  tags = local.tags
}

resource "azurerm_storage_container" "app_data" {
  name                  = "appdata"
  storage_account_name  = azurerm_storage_account.app_storage.name
  container_access_type = "private"
}

# Use our VNET module
module "network" {
  source              = "../../modules/vnet"
  vnet_name           = "vnet-${var.project_name}-${local.environment}-${local.location}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]
  
  subnets = {
    "app-subnet" = {
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
        },
        {
          name                       = "allow-ssh"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = var.admin_cidr_blocks
          destination_address_prefix = "*"
        }
      ]
    },
    "db-subnet" = {
      address_prefix    = "10.0.2.0/24"
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
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
        }
      ]
    }
  }
  
  tags = local.tags
}

# Create a VM for development
resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-vm-${var.project_name}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.subnet_ids["app-subnet"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "dev_vm" {
  name                = "vm-${var.project_name}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}