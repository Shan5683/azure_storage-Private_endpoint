resource "azurerm_private_dns_zone" "blob_dns" {

  for_each = var.private_dns_zones

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob_dns_link" {

  for_each = var.private_dns_zones

  name                  = each.value.link_name
  private_dns_zone_id   = azurerm_private_dns_zone.blob_dns[each.key].id
  virtual_network_id    = var.virtual_network_id
}