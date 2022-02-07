resource "azurerm_availability_set" "master" {
  name                = "AST${var.cluster_name}MASTER"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
  managed             = true
}