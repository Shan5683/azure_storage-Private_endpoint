output "private_dns_zone_id" {
  value = {
    for key, dns in azurerm_private_dns_zone.blob_dns :
    key => dns.id
  }
}