output "map" {
  value = "${
      map(
          "id",             "${azurerm_user_assigned_identity.msi.id}",
          "principal_id",   "${azurerm_user_assigned_identity.msi.principal_id}",
          "client_id",      "${azurerm_user_assigned_identity.msi.client_id}"
      )
  }"
}
