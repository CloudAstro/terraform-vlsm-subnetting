# --- VLSM Subnet Calculations ---
locals {
  vlsm_subnets = var.vnet_cidr_blocks != null ? {
    for vnet_name, config in var.vnet_cidr_blocks : vnet_name => {
      for i in range(length(config.aliases)) :
      config.aliases[i] => cidrsubnet(
        config.vnet_base_cidr_block,
        config.newbits[i],
        config.netnum[i]
      )
    }
  } : {}
}

# --- Subnet Configuration Mapping ---
locals {
  subnets = var.subnets != null ? {
    for vnet_name, config in var.subnets : vnet_name => {
      for i in range(length(config.aliases)) :
      config.aliases[i] => {
        name   = config.names[i]
        prefix = config.prefixes[i]
      }
    }
  } : {}
}

# --- Helper Local to Avoid Null Checks Repetition ---
locals {
  has_subnets = var.subnets != null
}

# --- Extracted Values: Names & Prefixes ---
locals {
  subnet_names = local.has_subnets ? {
    for vnet_name, alias_map in local.subnets : vnet_name => [
      for alias, subnet in alias_map : subnet.name
    ]
  } : {}

  subnet_prefixes = local.has_subnets ? {
    for vnet_name, alias_map in local.subnets : vnet_name => [
      for alias, subnet in alias_map : subnet.prefix
    ]
  } : {}
}

# --- Flattened Lookup Maps for Alias -> Name/Prefix ---
locals {
  subnet_alias_to_name = local.has_subnets ? merge([
    for _, alias_map in local.subnets : {
      for alias, subnet in alias_map : alias => subnet.name
    }
  ]...) : {}

  subnet_alias_to_prefix = local.has_subnets ? merge([
    for _, alias_map in local.subnets : {
      for alias, subnet in alias_map : alias => subnet.prefix
    }
  ]...) : {}
}
