output "route_table_ids" {

  value = {
    for key, rt in azurerm_route_table.rt :
    key => rt.id
  }
}