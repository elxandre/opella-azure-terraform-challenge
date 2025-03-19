ß# Add validation rules for inputs
locals {
  # Validate NSG rule priorities are unique per subnet
  validate_priority_uniqueness = flatten([
    for subnet_key, subnet in var.subnets : [
      for rule_index, rule in lookup(subnet, "nsg_rules", []) : [
        for inner_rule_index, inner_rule in lookup(subnet, "nsg_rules", []) : {
          subnet_name = subnet_key
          rule1       = rule.name
          rule2       = inner_rule.name
          priority1   = rule.priority
          priority2   = inner_rule.priority
          is_duplicate = rule.priority == inner_rule.priority && rule_index != inner_rule_index
        }
      ]
    ] if lookup(subnet, "create_nsg", false)
  ])

  # Check for any duplicates
  has_duplicate_priorities = length([
    for item in local.validate_priority_uniqueness : item if item.is_duplicate
  ]) > 0

  # Build error message
  duplicate_priority_error = local.has_duplicate_priorities ? "Duplicate NSG rule priorities found: ${jsonencode([
    for item in local.validate_priority_uniqueness : 
      "Subnet '${item.subnet_name}' has rules '${item.rule1}' and '${item.rule2}' with same priority ${item.priority1}" 
      if item.is_duplicate
  ])}" : null
}

# Custom validation rules
resource "null_resource" "validate_nsg_priorities" {
  count = local.has_duplicate_priorities ? 0 : 1

  lifecycle {
    precondition {
      condition     = !local.has_duplicate_priorities
      error_message = local.duplicate_priority_error
    }
  }
}