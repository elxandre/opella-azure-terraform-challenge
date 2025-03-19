# Azure Virtual Network Terraform Module

This Terraform module deploys an Azure Virtual Network with associated subnets and optional security features.

## Features

- Virtual Network with customizable address space
- Multiple subnet creation with flexible configuration
- Network Security Groups with rule management
- Support for service endpoints
- Subnet delegations for Azure services
- Optional Network Watcher flow logs with Traffic Analytics
- Comprehensive tagging system

## Usage

```hcl
module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = "my-vnet"
  resource_group_name = "my-resource-group"
  location            = "eastus"
  address_space       = ["10.0.0.0/16"]
  
  subnets = {
    "subnet1" = {
      address_prefix   = "10.0.1.0/24"
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
    "subnet2" = {
      address_prefix  = "10.0.2.0/24"
      create_nsg      = false
    }
  }
  
  tags = {
    environment = "development"
    project     = "my-project"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vnet_name | Name of the virtual network | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region where resources will be created | `string` | n/a | yes |
| address_space | Address space for the virtual network | `list(string)` | `["10.0.0.0/16"]` | no |
| dns_servers | List of DNS servers to use with the virtual network | `list(string)` | `[]` | no |
| subnets | Map of subnet objects. Key is subnet name, value is subnet properties | `map(object({...}))` | `{}` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |
| default_tags | Default tags applied to all resources | `map(string)` | `{ managed_by = "terraform" }` | no |
| enable_network_monitoring | Enable network monitoring features like flow logs | `bool` | `false` | no |
| network_watcher_name | Name of the Network Watcher to store flow logs | `string` | `null` | no |
| network_watcher_resource_group_name | Resource group name of the Network Watcher | `string` | `null` | no |

See `variables.tf` for additional variable definitions and details.

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | ID of the Virtual Network |
| vnet_name | Name of the Virtual Network |
| vnet_address_space | Address space of the Virtual Network |
| subnet_ids | Map of subnet names to subnet IDs |
| subnet_address_prefixes | Map of subnet names to address prefixes |
| nsg_ids | Map of subnet names to NSG IDs |

## Security Considerations

This module includes several security features:

1. Network Security Groups with customizable rules
2. Network Watcher flow logs for monitoring network traffic
3. Traffic Analytics for advanced threat detection
4. Service Endpoints for securing connections to Azure services

## Testing

This module includes automated tests using Terratest. To run the tests:

```bash
cd test
go test -v
```