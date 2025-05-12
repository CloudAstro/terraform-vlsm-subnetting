variable "vnet_cidr_blocks" {
  type = map(object({
    vnet_base_cidr_block = string
    aliases              = list(string)
    newbits              = list(number)
    netnum               = list(number)
  }))
  default     = null
  description = <<DESCRIPTION
  * `vnet_cidr_blocks` - (Required) A mapping of virtual network CIDR block configurations.
    Each key in the map represents a unique virtual network, and the value is an object containing the following attributes:
    * `vnet_base_cidr_block` - (Required) The base CIDR block for the virtual network.
    * `aliases` - (Required) A list of aliases for the subnets within the virtual network.
    * `newbits` - (Required) A list of numbers representing the new bits for the subnet masks.
    * `netnum` - (Required) A list of numbers representing the subnet numbers.

  Example input:
  ```
  vnet_cidr_blocks = {
    vnet1 = {
      vnet_base_cidr_block  = "10.0.0.0/16"
      aliases               = ["subnet1", "subnet2"]
      newbits               = [8, 8]
      netnum                = [1, 2]
    }
    vnet2 = {
      vnet_base_cidr_block  = "192.168.0.0/16"
      aliases               = ["subnetA", "subnetB"]
      newbits               = [8, 8]
      netnum                = [10, 20]
    }
  }
  ```
  DESCRIPTION
}

variable "subnets" {
  type = map(object({
    aliases  = list(string)
    prefixes = list(string)
    names    = list(string)
  }))
  default     = null
  description = <<DESCRIPTION
  * `subnets` - (Required) A mapping of subnet configurations.
    Each key in the map represents a unique subnet configuration group, and the value is an object containing the following attributes:
    * `aliases` - (Required) A list of aliases for the subnets.
    * `prefixes` - (Required) A list of prefixes for the subnets.
    * `names` - (Required) A list of names for the subnets.

  Example input:
  ```
  subnets = {
    group1 = {
      aliases = ["alias1", "alias2"]
      prefixes = ["10.0.1.0/24", "10.0.2.0/24"]
      names = ["subnet1", "subnet2"]
    }
    group2 = {
      aliases = ["aliasA", "aliasB"]
      prefixes = ["192.168.1.0/24", "192.168.2.0/24"]
      names = ["subnetA", "subnetB"]
    }
  }
DESCRIPTION
}
