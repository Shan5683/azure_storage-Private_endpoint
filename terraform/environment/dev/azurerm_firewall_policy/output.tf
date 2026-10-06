output "firewall_policy_ids" {
  value = {
    for key, policy in azurerm_firewall_policy.firewall-policy :
    key => policy.id
  }
}