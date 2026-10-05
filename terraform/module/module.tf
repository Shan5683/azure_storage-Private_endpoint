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
  source = "../environment/dev/azurerm_storage_container"

  containers = {
    container1 = {
      name                  = "tfstate"
      storage_account_id    = module.stg.storage_account_id["stg1"]
      container_access_type = "private"
    }
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


