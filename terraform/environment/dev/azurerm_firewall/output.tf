output "firewall_private_ip" {

  value = {
    for key, fw in azurerm_firewall.fw :
    key => fw.ip_configuration[0].private_ip_address
  }
}

output "firewall_id" {

  value = {
    for key, fw in azurerm_firewall.fw :
    key => fw.id
  }
}