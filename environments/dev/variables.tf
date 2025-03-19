variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "owner" {
  description = "Owner of the project"
  type        = string
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks that are allowed to access administrative services"
  type        = string
  default     = "0.0.0.0/0"  # Should be restricted in production
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

# environments/dev/outputs.tf

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

output "storage_account_primary_access_key" {
  description = "Primary access key for the storage account"
  value       = azurerm_storage_account.app_storage.primary_access_key
  sensitive   = true
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}