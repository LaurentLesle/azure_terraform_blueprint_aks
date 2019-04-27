resource "azuread_application" "app" {
  name                       = "${var.prefix}-${var.name}"
}

resource "azuread_service_principal" "sp" {
  application_id = "${azuread_application.app.application_id}"
}

resource "random_string" "pwd" {
    length  = 70
    upper   = true
    special = true
}

resource "azuread_service_principal_password" "pwd" {
  service_principal_id = "${azuread_service_principal.sp.id}"
  value                = "${random_string.pwd.result}"
  end_date             = "${var.end_date}"
}