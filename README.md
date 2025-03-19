# opella-azure-terraform-challenge
Azure Virtual Network Terraform Module
This Terraform module deploys an Azure Virtual Network with associated subnets and optional security features.
Features

Virtual Network with customizable address space
Multiple subnet creation with flexible configuration
Network Security Groups with rule management
Support for service endpoints
Subnet delegations for Azure services
Optional Network Watcher flow logs with Traffic Analytics
Comprehensive tagging system

Usage
hclCopymodule "vnet" {
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
Requirements
NameVersionterraform>= 1.0.0azurerm>= 3.0.0
Inputs
NameDescriptionTypeDefaultRequiredvnet_nameName of the virtual networkstringn/ayesresource_group_nameName of the resource groupstringn/ayeslocationAzure region where resources will be createdstringn/ayesaddress_spaceAddress space for the virtual networklist(string)["10.0.0.0/16"]nodns_serversList of DNS servers to use with the virtual networklist(string)[]nosubnetsMap of subnet objects. Key is subnet name, value is subnet propertiesmap(object({...})){}notagsTags to apply to resourcesmap(string){}nodefault_tagsDefault tags applied to all resourcesmap(string){ managed_by = "terraform" }noenable_network_monitoringEnable network monitoring features like flow logsboolfalsenonetwork_watcher_nameName of the Network Watcher to store flow logsstringnullnonetwork_watcher_resource_group_nameResource group name of the Network Watcherstringnullno
See variables.tf for additional variable definitions and details.
Outputs
NameDescriptionvnet_idID of the Virtual Networkvnet_nameName of the Virtual Networkvnet_address_spaceAddress space of the Virtual Networksubnet_idsMap of subnet names to subnet IDssubnet_address_prefixesMap of subnet names to address prefixesnsg_idsMap of subnet names to NSG IDs
Security Considerations
This module includes several security features:

Network Security Groups with customizable rules
Network Watcher flow logs for monitoring network traffic
Traffic Analytics for advanced threat detection
Service Endpoints for securing connections to Azure services

Testing
This module includes automated tests using Terratest. To run the tests:
bashCopycd test
go test -v
