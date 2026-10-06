resource "azurerm_firewall" "fw" {

  for_each = var.firewalls

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  sku_name = each.value.sku_name
  sku_tier = each.value.sku_tier

  firewall_policy_id = each.value.firewall_policy_id

  ip_configuration {
    name                 = "firewall-ipconfig"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = each.value.public_ip_address_id
  }
}