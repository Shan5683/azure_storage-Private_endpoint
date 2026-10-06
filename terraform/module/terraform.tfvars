rg = {
  rg1 = {
    name     = "drishiamrg"
    location = "East US"
  }
}

stg = {
  stg1 = {
    name                          = "shanstorage12345"
    resource_group_name           = "drishiamrg"
    location                      = "East US"
    account_tier                  = "Standard"
    account_replication_type      = "LRS"
    public_network_access_enabled = false
  }
}

stg_containers = {
  container1 = {
    name                  = "tfstate"
    storage_account_key   = "stg1"
    container_access_type = "private"
  }
}

vnet = {
  vnet1 = {
    name                = "shanstoragevnet"
    address_space       = ["10.0.0.0/16"]
    location            = "East US"
    resource_group_name = "drishiamrg"
  }
}

sub = {
  subnet1 = {
    name                 = "shansubnet"
    address_prefixes     = ["10.0.2.0/24"]
    resource_group_name  = "drishiamrg"
    virtual_network_name = "shanstoragevnet"
  }

    firewall-subnet = {

    name                 = "AzureFirewallSubnet"
    resource_group_name  = "drishiamrg"
    virtual_network_name = "shanstoragevnet"

    address_prefixes = ["10.0.1.0/26"]
  }
}

private_d_z = {
  pdz1 = {
    name                = "privatelink.blob.core.windows.net"
    resource_group_name = "drishiamrg"
    link_name           = "shanstorageprivatednszonelink"
  }
}

pe = {
  pe1 = {
    name                = "shanstoragepe"
    connection_name     = "shanstoragepeconnection"
    subresource         = "blob"
    location            = "East US"
    resource_group_name = "drishiamrg"
  }
}

public_ips = {
  fw-pip = {
    name              = "fw-pip"
    location          = "East US"
    resource_group_name = "drishiamrg"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

firewall_policies = {

  fw-policy = {

    name                = "shan-fw-policy"
    location            = "East US"
    resource_group_name = "drishiamrg"
    sku                 = "Standard"

  }
}

firewalls = {

  firewall1 = {

    name                = "shan-firewall"
    location            = "East US"
    resource_group_name = "drishiamrg"

    sku_name = "AZFW_VNet"
    sku_tier = "Standard"

  }
}

route_tables = {

  firewall-udr = {

    name                = "shan-firewall-udr"
    location            = "East US"
    resource_group_name = "drishiamrg"

     route_name          = "default-route"
    address_prefix      = "0.0.0.0/0"
    next_hop_type       = "VirtualAppliance"

  }
}

subnet_route_table_associations = {
  "app-subnet" = {
    subnet_key      = "subnet1"
    route_table_key = "firewall-udr"
  }
}