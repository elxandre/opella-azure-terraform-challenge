output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "Map of subnet names to subnet IDs"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to address prefixes"
  value       = { for k, v in azurerm_subnet.subnet : k => v.address_prefixes[0] }
}

output "nsg_ids" {
  description = "Map of subnet names to NSG IDs"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}