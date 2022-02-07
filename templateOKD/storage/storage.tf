resource "azurerm_storage_account" "storage" {
  name                = "${var.name}"
  resource_group_name = "${var.rg_name}"

  location                 = "${var.rg_location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "storage" {
  name                  = "ocp-registry"
  resource_group_name   = "${var.rg_name}"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}