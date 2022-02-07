resource "azurerm_application_security_group" "asg" {
  name                = "ASG${var.cluster_name}"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
}


output "asg_name" {
  value = "${azurerm_application_security_group.asg.name}"
}

output "asg_id" {
  value = "${azurerm_application_security_group.asg.id}"
}
