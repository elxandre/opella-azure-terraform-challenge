Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions

  # azurerm_linux_virtual_machine.dev_vm will be created
  + resource "azurerm_linux_virtual_machine" "dev_vm" {
      + admin_username                  = "adminuser"
      + allow_extension_operations      = true
      + computer_name                   = (known after apply)
      + disable_password_authentication = true
      + encryption_at_host_enabled      = false
      + id                              = (known after apply)
      + location                        = "eastus"
      + max_bid_price                   = -1
      + name                            = "vm-opella-dev"
      + network_interface_ids           = (known after apply)
      + patch_assessment_mode           = "ImageDefault"
      + patch_mode                      = "ImageDefault"
      + platform_fault_domain           = -1
      + priority                        = "Regular"
      + private_ip_address              = (known after apply)
      + private_ip_addresses            = (known after apply)
      + provision_vm_agent              = true
      + public_ip_address               = (known after apply)
      + public_ip_addresses             = (known after apply)
      + resource_group_name             = "rg-opella-dev-eastus"
      + size                            = "Standard_B1s"
      + virtual_machine_id              = (known after apply)

      + admin_ssh_key {
          + public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0/NDMj2wG9WfCLQFxoMjRFN7Wt5f0cddVplQFNgKBvq9SLjfGZGGE7MmWxCEPPn+WYxZCbVUCmcogJH6P4TQRNPx/ksYQl+TvZFT4qYvqEtXvpKXLU6wQ+D1PCZOhHbVn0AXjMo+X0l7CsACdGVyRYZF1yUoai5bUQngBWvKbQEiKFj3EpfQQEcb4LGzXe5TdEjiIChKjPnQLSRsg3zqbPXLGEYMhEtW817rOSIRWS8oLfYyY+4zIFf8L3oBpMtkPdqEHlKc0ooGphD3SXD/iVxPAQIDxohWGdQGJ/6+Vjf9j9A3a/9/xI9Fd+1xMEJKdtIeRTAGDmGxHgBJGdCGv sample"
          + username   = "adminuser"
        }

      + os_disk {
          + caching                   = "ReadWrite"
          + disk_size_gb              = (known after apply)
          + name                      = (known after apply)
          + storage_account_type      = "Standard_LRS"
          + write_accelerator_enabled = false
        }

      + source_image_reference {
          + offer     = "0001-com-ubuntu-server-jammy"
          + publisher = "Canonical"
          + sku       = "22_04-lts"
          + version   = "latest"
        }
    }

  # azurerm_network_interface.vm_nic will be created
  + resource "azurerm_network_interface" "vm_nic" {
      + applied_dns_servers           = (known after apply)
      + dns_servers                   = (known after apply)
      + enable_accelerated_networking = false
      + enable_ip_forwarding          = false
      + id                            = (known after apply)
      + internal_dns_name_label       = (known after apply)
      + internal_domain_name_suffix   = (known after apply)
      + location                      = "eastus"
      + mac_address                   = (known after apply)
      + name                          = "nic-vm-opella-dev"
      + private_ip_address            = (known after apply)
      + private_ip_addresses          = (known after apply)
      + resource_group_name           = "rg-opella-dev-eastus"
      + virtual_machine_id            = (known after apply)

      + ip_configuration {
          + gateway_load_balancer_frontend_ip_configuration_id = (known after apply)
          + name                                               = "internal"
          + primary                                            = (known after apply)
          + private_ip_address                                 = (known after apply)
          + private_ip_address_allocation                      = "Dynamic"
          + private_ip_address_version                         = "IPv4"
          + subnet_id                                          = (known after apply)
        }
    }
    
  # azurerm_resource_group.main will be created
  + resource "azurerm_resource_group" "main" {
      + id       = (known after apply)
      + location = "eastus"
      + name     = "rg-opella-dev-eastus"
      + tags     = {
          + "Environment" = "dev"
          + "ManagedBy"   = "Terraform"
          + "Owner"       = "devops-team"
          + "Project"     = "opella"
        }
    }

  # azurerm_storage_account.app_storage will be created
  + resource "azurerm_storage_account" "app_storage" {
      + access_tier                      = (known after apply)
      + account_kind                     = "StorageV2"
      + account_replication_type         = "LRS"
      + account_tier                     = "Standard"
      + allow_nested_items_to_be_public  = true
      + enable_https_traffic_only        = true
      + id                               = (known after apply)
      + infrastructure_encryption_enabled = false
      + is_hns_enabled                   = false
      + large_file_share_enabled         = (known after apply)
      + location                         = "eastus"
      + min_tls_version                  = "TLS1_2"
      + name                             = "stopalladeveastus"
      + nfsv3_enabled                    = false
      + primary_access_key               = (sensitive value)
      + primary_blob_connection_string   = (sensitive value)
      + primary_blob_endpoint            = (known after apply)
      + primary_blob_host                = (known after apply)
      + primary_connection_string        = (sensitive value)
      + primary_dfs_endpoint             = (known after apply)
      + primary_dfs_host                 = (known after apply)
      + primary_file_endpoint            = (known after apply)
      + primary_file_host                = (known after apply)
      + primary_location                 = (known after apply)
      + primary_queue_endpoint           = (known after apply)
      + primary_queue_host               = (known after apply)
      + primary_table_endpoint           = (known after apply)
      + primary_table_host               = (known after apply)
      + primary_web_endpoint             = (known after apply)
      + primary_web_host                 = (known after apply)
      + public_network_access_enabled    = true
      + queue_encryption_key_type        = "Service"
      + resource_group_name              = "rg-opella-dev-eastus"
      + secondary_access_key             = (sensitive value)
      + secondary_blob_connection_string = (sensitive value)
      + secondary_blob_endpoint          = (known after apply)
      + secondary_blob_host              = (known after apply)
      + secondary_connection_string      = (sensitive value)
      + secondary_dfs_endpoint           = (known after apply)
      + secondary_dfs_host               = (known after apply)
      + secondary_file_endpoint          = (known after apply)
      + secondary_file_host              = (known after apply)
      + secondary_location               = (known after apply)
      + secondary_queue_endpoint         = (known after apply)
      + secondary_queue_host             = (known after apply)
      + secondary_table_endpoint         = (known after apply)
      + secondary_table_host             = (known after apply)
      + secondary_web_endpoint           = (known after apply)
      + secondary_web_host               = (known after apply)
      + shared_access_key_enabled        = true
      + table_encryption_key_type        = "Service"
      + tags                             = {
          + "Environment" = "dev"
          + "ManagedBy"   = "Terraform"
          + "Owner"       = "devops-team"
          + "Project"     = "opella"
        }

      + blob_properties {
          + change_feed_enabled      = false
          + last_access_time_enabled = false
          + versioning_enabled       = false

          + container_delete_retention_policy {
              + days = 7
            }

          + delete_retention_policy {
              + days = 7
            }
        }
    }
    
  # azurerm_storage_container.app_data will be created
  + resource "azurerm_storage_container" "app_data" {
      + container_access_type   = "private"
      + has_immutability_policy = (known after apply)
      + has_legal_hold          = (known after apply)
      + id                      = (known after apply)
      + metadata                = (known after apply)
      + name                    = "appdata"
      + resource_manager_id     = (known after apply)
      + storage_account_name    = "stopalladeveastus"
    }

  # module.network.azurerm_network_security_group.nsg["app-subnet"] will be created
  + resource "azurerm_network_security_group" "nsg" {
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "vnet-opella-dev-eastus-app-subnet-nsg"
      + resource_group_name = "rg-opella-dev-eastus"
      + security_rule       = (known after apply)
      + tags                = {
          + "Environment" = "dev"
          + "ManagedBy"   = "Terraform"
          + "Owner"       = "devops-team"
          + "Project"     = "opella"
          + "managed_by"  = "terraform"
        }
    }

  # module.network.azurerm_network_security_group.nsg["db-subnet"] will be created
  + resource "azurerm_network_security_group" "nsg" {
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "vnet-opella-dev-eastus-db-subnet-nsg"
      + resource_group_name = "rg-opella-dev-eastus"
      + security_rule       = (known after apply)
      + tags                = {
          + "Environment" = "dev"
          + "ManagedBy"   = "Terraform"
          + "Owner"       = "devops-team"
          + "Project"     = "opella"
          + "managed_by"  = "terraform"
        }
    }

  # module.network.azurerm_network_security_rule.nsg_rules["app-subnet-allow-https"] will be created
  + resource "azurerm_network_security_rule" "nsg_rules" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "443"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "allow-https"
      + network_security_group_name = "vnet-opella-dev-eastus-app-subnet-nsg"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "rg-opella-dev-eastus"
      + source_address_prefix       = "*"
      + source_port_range           = "*"
    }
    
  # module.network.azurerm_network_security_rule.nsg_rules["app-subnet-allow-ssh"] will be created
  + resource "azurerm_network_security_rule" "nsg_rules" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "22"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "allow-ssh"
      + network_security_group_name = "vnet-opella-dev-eastus-app-subnet-nsg"
      + priority                    = 110
      + protocol                    = "Tcp"
      + resource_group_name         = "rg-opella-dev-eastus"
      + source_address_prefix       = "0.0.0.0/0"
      + source_port_range           = "*"
    }

  # module.network.azurerm_network_security_rule.nsg_rules["db-subnet-allow-sql"] will be created
  + resource "azurerm_network_security_rule" "nsg_rules" {
      + access                      = "Allow"
      + destination_address_prefix  = "*"
      + destination_port_range      = "1433"
      + direction                   = "Inbound"
      + id                          = (known after apply)
      + name                        = "allow-sql"
      + network_security_group_name = "vnet-opella-dev-eastus-db-subnet-nsg"
      + priority                    = 100
      + protocol                    = "Tcp"
      + resource_group_name         = "rg-opella-dev-eastus"
      + source_address_prefix       = "10.0.1.0/24"
      + source_port_range           = "*"
    }

  # module.network.azurerm_subnet.subnet["app-subnet"] will be created
  + resource "azurerm_subnet" "subnet" {
      + address_prefixes                               = [
          + "10.0.1.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = "app-subnet"
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = "rg-opella-dev-eastus"
      + service_endpoint_policy_ids                    = (known after apply)
      + service_endpoints                              = [
          + "Microsoft.KeyVault",
          + "Microsoft.Storage",
        ]
      + virtual_network_name                           = "vnet-opella-dev-eastus"
    }
    
  # module.network.azurerm_subnet.subnet["db-subnet"] will be created
  + resource "azurerm_subnet" "subnet" {
      + address_prefixes                               = [
          + "10.0.2.0/24",
        ]
      + enforce_private_link_endpoint_network_policies = (known after apply)
      + enforce_private_link_service_network_policies  = (known after apply)
      + id                                             = (known after apply)
      + name                                           = "db-subnet"
      + private_endpoint_network_policies_enabled      = (known after apply)
      + private_link_service_network_policies_enabled  = (known after apply)
      + resource_group_name                            = "rg-opella-dev-eastus"
      + service_endpoint_policy_ids                    = (known after apply)
      + service_endpoints                              = [
          + "Microsoft.Sql",
          + "Microsoft.Storage",
        ]
      + virtual_network_name                           = "vnet-opella-dev-eastus"
    }

  # module.network.azurerm_subnet_network_security_group_association.nsg_association["app-subnet"] will be created
  + resource "azurerm_subnet_network_security_group_association" "nsg_association" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # module.network.azurerm_subnet_network_security_group_association.nsg_association["db-subnet"] will be created
  + resource "azurerm_subnet_network_security_group_association" "nsg_association" {
      + id                        = (known after apply)
      + network_security_group_id = (known after apply)
      + subnet_id                 = (known after apply)
    }

  # module.network.azurerm_virtual_network.vnet will be created
  + resource "azurerm_virtual_network" "vnet" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = []
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "eastus"
      + name                = "vnet-opella-dev-eastus"
      + resource_group_name = "rg-opella-dev-eastus"
      + subnet              = (known after apply)
      + tags                = {
          + "Environment" = "dev"
          + "ManagedBy"   = "Terraform"
          + "Owner"       = "devops-team"
          + "Project"     = "opella"
          + "managed_by"  = "terraform"
        }
    }

Plan: 13 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + resource_group_name              = "rg-opella-dev-eastus"
  + storage_account_name             = "stopalladeveastus"
  + storage_account_primary_access_key = (sensitive value)
  + subnet_ids                       = (known after apply)
  + vm_private_ip                    = (known after apply)
  + vnet_id                          = (known after apply)
  + vnet_name                        = "vnet-opella-dev-eastus"
