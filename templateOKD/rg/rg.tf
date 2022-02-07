resource "azurerm_resource_group" "cluster" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

output "name" {
  value = "${azurerm_resource_group.cluster.name}"
}
output "location" {
  value = "${azurerm_resource_group.cluster.location}"
}
