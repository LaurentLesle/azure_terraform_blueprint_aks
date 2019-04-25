output "service_principal_map" {
  value = "${
      map(
          "app_id",         "${azuread_application.app.application_id}",
          "object_id",      "${azuread_service_principal.sp.id}",
          "client_secret",  "${random_string.pwd.result}"
      )
  }"
}
