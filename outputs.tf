output "vlsm_subnets" {
  value       = local.vlsm_subnets
  description = <<DESCRIPTION
Mapping of VNET names to their associated VLSM (Variable Length Subnet Mask) subnets.
Each top-level key is a VNET name. The nested map has aliases as keys and their computed CIDR subnet as values.

Example output:
```
output_name = {
  vnet1 = {
    subnet1 = "10.0.1.0/24",
    subnet2 = "10.0.2.0/24"
  },
  vnet2 = {
    subnetA = "192.168.10.0/24",
    subnetB = "192.168.20.0/24"
  }
}
```
DESCRIPTION
}


output "subnets" {
  value       = local.subnets
  description = <<DESCRIPTION
Mapping of VNETs to their subnet configurations.
Each VNET key contains a nested map where each alias maps to an object with `name` and `prefix`.

Example output:
```
output_name = {
  hub-subnets = {
    waf-snet = {
      name = "snet-waf-gwc-nonprod",
      prefix = "10.0.1.0/24"
    },
    appgw-snet = {
      name = "snet-appgw-gwc-nonprod",
      prefix = "10.0.2.0/24"
    }
    },
  spoke-snets = {
    aks-snet = {
      name = "snet-aks-gwc-nonprod",
      prefix = "192.168.1.0/24"
    },
    app-snet = {
      name = "snet-app-gwc-nonprod",
      prefix = "192.168.2.0/24"
    }
  }
}
```
DESCRIPTION
}


output "subnet_names" {
  value       = local.subnet_names
  description = <<DESCRIPTION
Mapping of VNET names to a list of subnet names within each VNET.

Example output:
```
output_name = {
  hub-subnets   = ["snet-waf-gwc-nonprod", "snet-appgw-gwc-nonprod"],
  spoke-snets   = ["snet-aks-gwc-nonprod", "snet-app-gwc-nonprod"]
}
```
DESCRIPTION
}


output "subnet_prefixes" {
  value       = local.subnet_prefixes
  description = <<DESCRIPTION
Mapping of VNET names to a list of subnet CIDR prefixes within each VNET.

Example output:
```
output_name = {
  hub-subnets = ["10.0.1.0/24", "10.0.2.0/24"],
  spoke-snets = ["192.168.1.0/24", "192.168.2.0/24"]
}
```
DESCRIPTION
}


output "subnet_alias_to_name" {
  value       = local.subnet_alias_to_name
  description = <<DESCRIPTION
A mapping of subnet aliases to their corresponding subnet names.

Example output:
```
output_name = {
  waf-snet   = "snet-waf-gwc-nonprod",
  app-snet   = "snet-app-gwc-nonprod",
  aks-snet   = "snet-aks-gwc-nonprod"
}
```
DESCRIPTION
}

output "subnet_alias_to_prefix" {
  value       = local.subnet_alias_to_prefix
  description = <<DESCRIPTION
Flat mapping of subnet aliases to their corresponding CIDR prefixes.

Example output:
```
output_name = {
  waf-snet   = "10.0.1.0/24",
  app-snet   = "192.168.2.0/24",
  aks-snet   = "192.168.1.0/24"
}
```
DESCRIPTION
}
