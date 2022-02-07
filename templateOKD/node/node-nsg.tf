resource "azurerm_network_security_group" "nodeNsg" {
  name                = "NSG${var.cluster_name}NODE"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
}

resource "azurerm_network_security_rule" "nodeNsgSSH" {
  name                        = "node-ssh"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.nodeNsg.name}"
  description                 = "Openshift SSH from the bastions"
  source_address_prefix = "${var.bastion_ip}"
  destination_address_prefix = "*"
}


resource "azurerm_network_security_rule" "nodeNsgKubelet" {
  name                        = "node-node-kubelet"
  priority                    =  575
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "10250"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.nodeNsg.name}"
  description                 = "Openshift kubelet"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}


resource "azurerm_network_security_rule" "nodeNsgSdn" {
  name                        = "node-sdn"
  priority                    =  600
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  destination_port_range      = "4789"
  source_port_range           = "*"  
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.nodeNsg.name}"
  description                 = "Openshift Sdn"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}


resource "azurerm_network_security_rule" "nodeNsgSdn2" {
  name                        = "node-node-sdn"
  priority                    =  625
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"  
  destination_port_range      = "10256"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.nodeNsg.name}"
  description                 = "Openshift Load Balancer health check"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}

resource "azurerm_network_security_rule" "NodeDenyAll" {
  name                        = "DenyAll"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.nodeNsg.name}"

}
