resource "azurerm_firewall_policy" "firewall-policy" {

  for_each = var.firewall_policies

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
}