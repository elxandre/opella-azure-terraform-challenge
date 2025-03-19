
Terraform used the selected providers to generate the following execution
plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions

  # null_resource.allow_https will be created
  + resource "null_resource" "allow_https" {
      + id       = (known after apply)
      + triggers = {
          + "access"                      = "Allow"
          + "destination_address_prefix"  = "*"
          + "destination_port_range"      = "443"
          + "direction"                   = "Inbound"
          + "name"                        = "allow-https"
          + "network_security_group_name" = "nsg-app-subnet"
          + "priority"                    = "100"
          + "protocol"                    = "Tcp"
          + "resource_group_name"         = "rg-opella-dev-eastus"
          + "source_address_prefix"       = "*"
          + "source_port_range"           = "*"
        }
    }

  # null_resource.app_nsg will be created
  + resource "null_resource" "app_nsg" {
      + id       = (known after apply)
      + triggers = {
          + "location"            = "eastus"
          + "name"                = "nsg-app-subnet"
          + "resource_group_name" = "rg-opella-dev-eastus"
          + "tags"                = jsonencode(
                {
                  + Environment = "dev"
                  + ManagedBy   = "Terraform"
                  + Owner       = "devops-team"
                  + Project     = "opella"
                }
            )
        }
    }

  # null_resource.app_storage will be created
  + resource "null_resource" "app_storage" {
      + id       = (known after apply)
      + triggers = {
          + "account_replication_type" = "LRS"
          + "account_tier"             = "Standard"
          + "location"                 = "eastus"
          + "min_tls_version"          = "TLS1_2"
          + "name"                     = "stopelladev"
          + "resource_group_name"      = "rg-opella-dev-eastus"
          + "tags"                     = jsonencode(
                {
                  + Environment = "dev"
                  + ManagedBy   = "Terraform"
                  + Owner       = "devops-team"
                  + Project     = "opella"
                }
            )
        }
    }

  # null_resource.app_subnet will be created
  + resource "null_resource" "app_subnet" {
      + id       = (known after apply)
      + triggers = {
          + "address_prefixes"     = jsonencode(
                [
                  + "10.0.1.0/24",
                ]
            )
          + "name"                 = "app-subnet"
          + "resource_group_name"  = "rg-opella-dev-eastus"
          + "service_endpoints"    = jsonencode(
                [
                  + "Microsoft.Storage",
                  + "Microsoft.KeyVault",
                ]
            )
          + "virtual_network_name" = "vnet-opella-dev-eastus"
        }
    }

  # null_resource.db_subnet will be created
  + resource "null_resource" "db_subnet" {
      + id       = (known after apply)
      + triggers = {
          + "address_prefixes"     = jsonencode(
                [
                  + "10.0.2.0/24",
                ]
            )
          + "name"                 = "db-subnet"
          + "resource_group_name"  = "rg-opella-dev-eastus"
          + "service_endpoints"    = jsonencode(
                [
                  + "Microsoft.Storage",
                  + "Microsoft.Sql",
                ]
            )
          + "virtual_network_name" = "vnet-opella-dev-eastus"
        }
    }

  # null_resource.dev_vm will be created
  + resource "null_resource" "dev_vm" {
      + id       = (known after apply)
      + triggers = {
          + "admin_username"         = "adminuser"
          + "location"               = "eastus"
          + "name"                   = "vm-opella-dev"
          + "os_disk"                = jsonencode(
                {
                  + caching              = "ReadWrite"
                  + storage_account_type = "Standard_LRS"
                }
            )
          + "resource_group_name"    = "rg-opella-dev-eastus"
          + "size"                   = "Standard_B1s"
          + "source_image_reference" = jsonencode(
                {
                  + offer     = "0001-com-ubuntu-server-jammy"
                  + publisher = "Canonical"
                  + sku       = "22_04-lts"
                  + version   = "latest"
                }
            )
          + "tags"                   = jsonencode(
                {
                  + Environment = "dev"
                  + ManagedBy   = "Terraform"
                  + Owner       = "devops-team"
                  + Project     = "opella"
                }
            )
        }
    }

  # null_resource.resource_group will be created
  + resource "null_resource" "resource_group" {
      + id       = (known after apply)
      + triggers = {
          + "location" = "eastus"
          + "name"     = "rg-opella-dev-eastus"
          + "tags"     = jsonencode(
                {
                  + Environment = "dev"
                  + ManagedBy   = "Terraform"
                  + Owner       = "devops-team"
                  + Project     = "opella"
                }
            )
        }
    }

  # null_resource.vm_nic will be created
  + resource "null_resource" "vm_nic" {
      + id       = (known after apply)
      + triggers = {
          + "ip_configuration"    = jsonencode(
                {
                  + name                          = "internal"
                  + private_ip_address_allocation = "Dynamic"
                }
            )
          + "location"            = "eastus"
          + "name"                = "nic-vm-opella-dev"
          + "resource_group_name" = "rg-opella-dev-eastus"
          + "tags"                = jsonencode(
                {
                  + Environment = "dev"
                  + ManagedBy   = "Terraform"
                  + Owner       = "devops-team"
                  + Project     = "opella"
                }
            )
        }
    }

  # null_resource.vnet will be created
  + resource "null_resource" "vnet" {
      + id       = (known after apply)
      + triggers = {
          + "address_space"       = jsonencode(
                [
                  + "10.0.0.0/16",
                ]
            )
          + "location"            = "eastus"
          + "name"                = "vnet-opella-dev-eastus"
          + "resource_group_name" = "rg-opella-dev-eastus"
          + "tags"                = jsonencode(
                {
                  + Environment = "dev"
                  + ManagedBy   = "Terraform"
                  + Owner       = "devops-team"
                  + Project     = "opella"
                }
            )
        }
    }

Plan: 9 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + resource_group_name              = "rg-opella-dev-eastus"
  + storage_account_name             = "stopalladeveastus"
  + storage_account_primary_access_key = (sensitive value)
  + subnet_ids                       = (known after apply)
  + vm_private_ip                    = (known after apply)
  + vnet_id                          = (known after apply)
  + vnet_name                        = "vnet-opella-dev-eastus"