resource "azurerm_private_endpoint" "pe" {

  for_each = var.private_endpoints

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  subnet_id = each.value.subnet_id

  private_service_connection {

    name = "${each.value.name}-connection"

    private_connection_resource_id = each.value.storage_account_id

    is_manual_connection = false

    subresource_names = [
      "blob"
    ]
  }

  private_dns_zone_group {

    name = "${each.value.name}-dns-zone-group"

    private_dns_zone_ids = [
      each.value.private_dns_zone_id
    ]
  }
}
