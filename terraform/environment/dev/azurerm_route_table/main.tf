resource "azurerm_route_table" "rt" {

  for_each = var.route_tables

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_route" "route" {

  for_each = var.route_tables

  name                   = each.value.route_name
  resource_group_name    = each.value.resource_group_name
  route_table_name       = azurerm_route_table.rt[each.key].name

  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}