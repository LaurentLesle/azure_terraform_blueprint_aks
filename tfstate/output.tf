output "storage_account_name" {
  value = "${azurerm_storage_account.stg.name}"
}

output "container" {
  value = "${azurerm_storage_container.tfstate.name}"
}

output "access_key" {
    sensitive   = true
    value       = "${azurerm_storage_account.stg.primary_access_key}"
}

output "prefix" {
  value = "${random_string.prefix.result}"
}
