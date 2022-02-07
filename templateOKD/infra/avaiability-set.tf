resource "azurerm_availability_set" "infra" {
  name                = "AST${var.cluster_name}INFRA"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
  managed             = true
}