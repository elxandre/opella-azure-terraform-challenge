variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "owner" {
  description = "Owner of the project"
  type        = string
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks that are allowed to access administrative services"
  type        = string
}

variable "flow_logs_storage_account_id" {
  description = "Storage account ID for flow logs"
  type        = string
}

variable "ssl_certificate_data" {
  description = "Base64 encoded PFX certificate for the application gateway"
  type        = string
  sensitive   = true
}

variable "ssl_certificate_password" {
  description = "Password for the PFX certificate"
  type        = string
  sensitive   = true
}