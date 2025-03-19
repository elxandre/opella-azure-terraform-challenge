locals {
  # Flatten subnet NSG rules for easier iteration
  subnet_nsg_rules = flatten([
    for subnet_key, subnet in var.subnets : [
      for rule in lookup(subnet, "nsg_rules", []) : {
        subnet_name              = subnet_key
        rule_name                = rule.name
        priority                 = rule.priority
        direction                = rule.direction
        access                   = rule.access
        protocol                 = rule.protocol
        source_port_range        = rule.source_port_range
        destination_port_range   = rule.destination_port_range
        source_address_prefix    = rule.source_address_prefix
        destination_address_prefix = rule.destination_address_prefix
      }
    ] if lookup(subnet, "create_nsg", false)
  ])
}