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
