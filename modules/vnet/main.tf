resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = merge(var.tags, var.default_tags)
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", {}) != {} ? [1] : []
    
    content {
      name = each.value.delegation.name
      
      service_delegation {
        name    = each.value.delegation.service_delegation_name
        actions = lookup(each.value.delegation, "service_delegation_actions", null)
      }
    }
  }
}

resource "azurerm_network_security_group" "nsg" {
  for_each = { for k, v in var.subnets : k => v if lookup(v, "create_nsg", false) }

  name                = "${var.vnet_name}-${each.key}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, var.default_tags)
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = { for k, v in var.subnets : k => v if lookup(v, "create_nsg", false) }

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_network_security_rule" "nsg_rules" {
  for_each = { 
    for rule in local.subnet_nsg_rules : 
    "${rule.subnet_name}-${rule.rule_name}" => rule 
  }

  name                         = each.value.rule_name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = each.value.source_port_range
  destination_port_range       = each.value.destination_port_range
  source_address_prefix        = each.value.source_address_prefix
  destination_address_prefix   = each.value.destination_address_prefix
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.nsg[each.value.subnet_name].name
}

# Optional Network Watcher Flow Logs
resource "azurerm_network_watcher_flow_log" "flow_logs" {
  for_each = { for k, v in var.subnets : k => v if lookup(v, "enable_flow_logs", false) && var.enable_network_monitoring }

  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.network_watcher_resource_group_name

  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
  storage_account_id        = var.flow_logs_storage_account_id
  enabled                   = true
  version                   = 2

  retention_policy {
    enabled = true
    days    = var.flow_logs_retention_days
  }

  traffic_analytics {
    enabled               = var.enable_traffic_analytics
    workspace_id          = var.log_analytics_workspace_id
    workspace_region      = var.location
    workspace_resource_id = var.log_analytics_workspace_resource_id
    interval_in_minutes   = 10
  }
}