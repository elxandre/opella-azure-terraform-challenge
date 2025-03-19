variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "opella"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  description = "List of DNS servers to use with the virtual network"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Map of subnet objects. Key is subnet name, value is subnet properties"
  type        = map(object({
    address_prefix              = string
    service_endpoints           = optional(list(string), [])
    create_nsg                  = optional(bool, false)
    nsg_rules                   = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
    delegation                  = optional(object({
      name                       = string
      service_delegation_name    = string
      service_delegation_actions = optional(list(string))
    }))
    enable_flow_logs            = optional(bool, false)
  }))
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default     = {
    managed_by = "terraform"
  }
}

# Network monitoring variables
variable "enable_network_monitoring" {
  description = "Enable network monitoring features like flow logs"
  type        = bool
  default     = false
}

variable "network_watcher_name" {
  description = "Name of the Network Watcher to store flow logs"
  type        = string
  default     = null
}

variable "network_watcher_resource_group_name" {
  description = "Resource group name of the Network Watcher"
  type        = string
  default     = null
}

variable "flow_logs_storage_account_id" {
  description = "Storage account ID to store flow logs"
  type        = string
  default     = null
}

variable "flow_logs_retention_days" {
  description = "Number of days to retain flow logs"
  type        = number
  default     = 7
}

variable "enable_traffic_analytics" {
  description = "Enable Traffic Analytics for flow logs"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Traffic Analytics"
  type        = string
  default     = null
}

variable "log_analytics_workspace_resource_id" {
  description = "Resource ID of the Log Analytics workspace"
  type        = string
  default     = null
}

# For firewall/bastion support
variable "create_firewall" {
  description = "Create Azure Firewall in the virtual network"
  type        = bool
  default     = false
}

variable "create_bastion" {
  description = "Create Azure Bastion in the virtual network"
  type        = bool
  default     = false
}