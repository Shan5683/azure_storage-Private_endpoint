output "storage_account_id" {
  value = {
    for key, stg in azurerm_storage_account.storage :
    key => stg.id
  }
}