<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
# Terraform VLSM Subnetting Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md)[![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE)[![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE)[![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/cloudastro/vlsm/core/)

This Terraform module calculates subnet CIDR blocks using **Variable Length Subnet Masking (VLSM)** based on a user-defined base CIDR block. It is designed to support **any cloud provider** or on-premise network environment where CIDR-based subnetting is required.

## Features

- **VLSM-Based Subnetting**: Dynamically calculate subnets from a base CIDR using `newbits` and `netnum`.
- **Flexible Input Structure**: Define subnets using human-readable aliases and modular input blocks.
- **Cloud-Agnostic Design**: Use with AWS, Azure, GCP, or any platform requiring CIDR planning.
- **Structured Output**: Returns a nested map of subnet aliases and their computed CIDRs, ideal for consumption by other modules.

## Example Usage

```hcl
resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-example"
  location = "germanywestcentral"
}

module "vlsm" {
  source = "../../"

  vnet_cidr_blocks = {
    vnet_addr_prefixes = {
      vnet_base_cidr_block = "10.0.0.0/24"
      aliases              = ["firewall", "hub", "spoke"]
      newbits              = [4, 4, 4]
      netnum               = [0, 1, 2]
    }
  }

  subnets = {
    prod-subnets = {
      aliases = ["firewall-snet", "hub-snet", "spoke-snet"]
      prefixes = [
        module.vlsm.vlsm_subnets.vnet_addr_prefixes.firewall,
        module.vlsm.vlsm_subnets.vnet_addr_prefixes.hub,
        module.vlsm.vlsm_subnets.vnet_addr_prefixes.spoke
      ]
      names = [
        "snet-firewall-gwc-prod",
        "snet-hub-gwc-prod",
        "snet-spoke-gwc-prod"
      ]
    }
  }
}

module "vnet-test" {
  source = "CloudAstro/virtual-network/azurerm"

  name                = "vnet-test"
  location            = azurerm_resource_group.vnetrg.location
  resource_group_name = azurerm_resource_group.vnetrg.name
  address_space       = values(module.vlsm.vlsm_subnets.vnet_addr_prefixes)
}

module "snet-test" {
  source = "CloudAstro/subnet/azurerm"

  for_each             = module.vlsm.subnets["prod-subnets"]
  name                 = each.value.name
  virtual_network_name = module.vnet-test.virtual_network.name
  resource_group_name  = azurerm_resource_group.vnetrg.name
  address_prefixes     = [each.value.prefix]
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |

## Providers

No providers.

## Resources

No resources.

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnets"></a> [subnets](#input\_subnets) | * `subnets` - (Required) A mapping of subnet configurations.<br/>    Each key in the map represents a unique subnet configuration group, and the value is an object containing the following attributes:<br/>    * `aliases` - (Required) A list of aliases for the subnets.<br/>    * `prefixes` - (Required) A list of prefixes for the subnets.<br/>    * `names` - (Required) A list of names for the subnets.<br/><br/>  Example input:<pre>subnets = {<br/>    group1 = {<br/>      aliases = ["alias1", "alias2"]<br/>      prefixes = ["10.0.1.0/24", "10.0.2.0/24"]<br/>      names = ["subnet1", "subnet2"]<br/>    }<br/>    group2 = {<br/>      aliases = ["aliasA", "aliasB"]<br/>      prefixes = ["192.168.1.0/24", "192.168.2.0/24"]<br/>      names = ["subnetA", "subnetB"]<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    aliases  = list(string)<br/>    prefixes = list(string)<br/>    names    = list(string)<br/>  }))</pre> | `null` | no |
| <a name="input_vnet_cidr_blocks"></a> [vnet\_cidr\_blocks](#input\_vnet\_cidr\_blocks) | * `vnet_cidr_blocks` - (Required) A mapping of virtual network CIDR block configurations.<br/>    Each key in the map represents a unique virtual network, and the value is an object containing the following attributes:<br/>    * `vnet_base_cidr_block` - (Required) The base CIDR block for the virtual network.<br/>    * `aliases` - (Required) A list of aliases for the subnets within the virtual network.<br/>    * `newbits` - (Required) A list of numbers representing the new bits for the subnet masks.<br/>    * `netnum` - (Required) A list of numbers representing the subnet numbers.<br/><br/>  Example input:<pre>vnet_cidr_blocks = {<br/>    vnet1 = {<br/>      vnet_base_cidr_block  = "10.0.0.0/16"<br/>      aliases               = ["subnet1", "subnet2"]<br/>      newbits               = [8, 8]<br/>      netnum                = [1, 2]<br/>    }<br/>    vnet2 = {<br/>      vnet_base_cidr_block  = "192.168.0.0/16"<br/>      aliases               = ["subnetA", "subnetB"]<br/>      newbits               = [8, 8]<br/>      netnum                = [10, 20]<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    vnet_base_cidr_block = string<br/>    aliases              = list(string)<br/>    newbits              = list(number)<br/>    netnum               = list(number)<br/>  }))</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_alias_to_name"></a> [subnet\_alias\_to\_name](#output\_subnet\_alias\_to\_name) | A mapping of subnet aliases to their corresponding subnet names.<br/><br/>Example output:<pre>output_name = {<br/>  waf-snet   = "snet-waf-gwc-nonprod",<br/>  app-snet   = "snet-app-gwc-nonprod",<br/>  aks-snet   = "snet-aks-gwc-nonprod"<br/>}</pre> |
| <a name="output_subnet_alias_to_prefix"></a> [subnet\_alias\_to\_prefix](#output\_subnet\_alias\_to\_prefix) | Flat mapping of subnet aliases to their corresponding CIDR prefixes.<br/><br/>Example output:<pre>output_name = {<br/>  waf-snet   = "10.0.1.0/24",<br/>  app-snet   = "192.168.2.0/24",<br/>  aks-snet   = "192.168.1.0/24"<br/>}</pre> |
| <a name="output_subnet_names"></a> [subnet\_names](#output\_subnet\_names) | Mapping of VNET names to a list of subnet names within each VNET.<br/><br/>Example output:<pre>output_name = {<br/>  hub-subnets   = ["snet-waf-gwc-nonprod", "snet-appgw-gwc-nonprod"],<br/>  spoke-snets   = ["snet-aks-gwc-nonprod", "snet-app-gwc-nonprod"]<br/>}</pre> |
| <a name="output_subnet_prefixes"></a> [subnet\_prefixes](#output\_subnet\_prefixes) | Mapping of VNET names to a list of subnet CIDR prefixes within each VNET.<br/><br/>Example output:<pre>output_name = {<br/>  hub-subnets = ["10.0.1.0/24", "10.0.2.0/24"],<br/>  spoke-snets = ["192.168.1.0/24", "192.168.2.0/24"]<br/>}</pre> |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Mapping of VNETs to their subnet configurations.<br/>Each VNET key contains a nested map where each alias maps to an object with `name` and `prefix`.<br/><br/>Example output:<pre>output_name = {<br/>  hub-subnets = {<br/>    waf-snet = {<br/>      name = "snet-waf-gwc-nonprod",<br/>      prefix = "10.0.1.0/24"<br/>    },<br/>    appgw-snet = {<br/>      name = "snet-appgw-gwc-nonprod",<br/>      prefix = "10.0.2.0/24"<br/>    }<br/>    },<br/>  spoke-snets = {<br/>    aks-snet = {<br/>      name = "snet-aks-gwc-nonprod",<br/>      prefix = "192.168.1.0/24"<br/>    },<br/>    app-snet = {<br/>      name = "snet-app-gwc-nonprod",<br/>      prefix = "192.168.2.0/24"<br/>    }<br/>  }<br/>}</pre> |
| <a name="output_vlsm_subnets"></a> [vlsm\_subnets](#output\_vlsm\_subnets) | Mapping of VNET names to their associated VLSM (Variable Length Subnet Mask) subnets.<br/>Each top-level key is a VNET name. The nested map has aliases as keys and their computed CIDR subnet as values.<br/><br/>Example output:<pre>output_name = {<br/>  vnet1 = {<br/>    subnet1 = "10.0.1.0/24",<br/>    subnet2 = "10.0.2.0/24"<br/>  },<br/>  vnet2 = {<br/>    subnetA = "192.168.10.0/24",<br/>    subnetB = "192.168.20.0/24"<br/>  }<br/>}</pre> |

## Modules

No modules.

## 🌐 Additional Information

This module provides a flexible, reusable solution for CIDR subnet planning using **Variable Length Subnet Masking (VLSM)**. It is cloud-agnostic and can be integrated with Terraform-based deployments across **AWS, Azure, GCP**, or **on-prem environments**. Ideal for teams that need deterministic and automated subnet allocation based on a single base CIDR.

## 📚 Resources

- [CIDR Subnetting Explained (RFC 4632)](https://datatracker.ietf.org/doc/html/rfc4632)
- [VLSM Overview](https://en.wikipedia.org/wiki/Variable-length_subnet_mask)
- [Terraform Language Documentation](https://developer.hashicorp.com/terraform/language)
- [OpenTofu (Terraform Fork) Registry](https://opentofu.org/)

## ⚠️ Notes

- The module does **not perform validation** on overlapping subnets — ensure your `newbits` and `netnum` combinations do not conflict.
- Intended to **calculate CIDRs only** — subnet creation (e.g., in Azure or AWS) should be handled by separate modules.
- Designed for use with **modular networking architectures** where subnet layout is dynamically generated.

## 🧾 License

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->