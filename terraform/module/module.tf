module "rg" {
  source          = "../environment/dev/azurerm_resource_group"
  resource_groups = var.rg

}

module "stg" {
  depends_on      = [module.rg]
  source          = "../environment/dev/azurerm_storage_account"
  storage_account = var.stg

}

module "container" {
  depends_on = [module.stg]
  source = "../environment/dev/azurerm_storage_container"

  containers = {
    for key, value in var.stg_containers : key => merge(
      value,
      {
        storage_account_id = module.stg.storage_account_id[value.storage_account_key]
      }
    )
  }
}


module "vnet" {
  depends_on      = [module.rg]
  source          = "../environment/dev/azurerm_virtual_network"
  virtual_network = var.vnet
}

module "subnet" {
  depends_on = [module.vnet]
  source     = "../environment/dev/azurerm_subnet"
  subnet     = var.sub
}

module "private_dns_zone" {
  depends_on         = [module.vnet]
  source             = "../environment/dev/azurerm_private_dns_zone"
  private_dns_zones  = var.private_d_z
  virtual_network_id = module.vnet.vnet_id["vnet1"]
}

module "pe" {
  depends_on = [module.subnet, module.stg, module.private_dns_zone]
  source     = "../environment/dev/azurerm_private_endpoint"

  private_endpoints = {
    for key, value in var.pe : key => merge(
      value,
      {
        subnet_id           = module.subnet.subnet_id["subnet1"]
        storage_account_id  = module.stg.storage_account_id["stg1"]
        private_dns_zone_id = module.private_dns_zone.private_dns_zone_id["pdz1"]
      }
    )
  }
}

module "public_ip" {
  depends_on = [module.rg]
  source = "../environment/dev/azurerm_public_ip"

  public_ips = var.public_ips
}

module "firewall_policy" {
  depends_on = [module.rg]
  source = "../environment/dev/azurerm_firewall_policy"

  firewall_policies = var.firewall_policies
}

module "firewall" {
  depends_on = [module.subnet, module.public_ip, module.firewall_policy]

  source = "../environment/dev/azurerm_firewall"

  firewalls = {
    for key, value in var.firewalls : key => merge(
      value,
      {
        firewall_policy_id   = module.firewall_policy.firewall_policy_ids["fw-policy"]
        subnet_id            = module.subnet.subnet_id["firewall-subnet"]
        public_ip_address_id = module.public_ip.public_ip_id["fw-pip"]
      }
    )
  }
}

module "route_table" {
  depends_on = [module.firewall]
  source = "../environment/dev/azurerm_route_table"

  route_tables = {
    for key, value in var.route_tables : key => merge(
      value,
      {
        next_hop_in_ip_address = module.firewall.firewall_private_ip["firewall1"]
      }
    )
  }
}

module "subnet_route_table_association" {
  depends_on = [module.subnet, module.route_table]
  source = "../environment/dev/azurerm_subnet_route_table_association"

  subnet_route_table_associations = {
    for key, value in var.subnet_route_table_associations : key => {
      subnet_id = module.subnet.subnet_id[value.subnet_key]

      route_table_id = module.route_table.route_table_ids[value.route_table_key]
    }
  }
}

