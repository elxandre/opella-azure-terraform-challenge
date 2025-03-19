output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "Name of the Virtual Network"
  value       = module.network.vnet_name
}

output "subnet_ids" {
  description = "Map of subnet names to IDs"
  value       = module.network.subnet_ids
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.app_storage.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "app_gateway_public_ip" {
  description = "Public IP of the Application Gateway"
  value       = azurerm_public_ip.appgw_pip.ip_address
}