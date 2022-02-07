resource "azurerm_availability_set" "node" {
  managed             =  true
  name                = "AST${var.cluster_name}NODE"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
}