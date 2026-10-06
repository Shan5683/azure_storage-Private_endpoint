output "public_ip_id" {

  value = {
    for key, pip in azurerm_public_ip.pip :
    key => pip.id
  }
}