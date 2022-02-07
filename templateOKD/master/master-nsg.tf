
resource "azurerm_network_security_group" "masterNsg" {

  name                = "NSG${var.cluster_name}MASTER"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
}

resource "azurerm_network_security_rule" "MasterNsgSSH" {
  name                        = "master-ssh"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range          =  "22"
  destination_port_range      = "22"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift SSH from the bastions"
  source_address_prefix = "${var.bastion_ip}"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "MasterNsgETCD" {
  name                        = "master-etcd"
  priority                    = 525
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_ranges          =  ["2379","2380"]
  destination_port_ranges      = ["2379","2380"]
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift ETCD service ports"
  destination_address_prefix = "*"
  source_address_prefix = "*"
}

resource "azurerm_network_security_rule" "masterNsgApi" {
  name                        = "master-api"
  priority                    = 550
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range          = "443"
  destination_port_range      = "443"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift API port"
  destination_address_prefix = "*"
  source_address_prefix = "*"
}

resource "azurerm_network_security_rule" "masterNsgApiLb" {
  name                        = "master-api-lb"
  priority                    = 575
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range          = "443"
  destination_port_range      = "443"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift API port"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]

}

resource "azurerm_network_security_rule" "masterNsgOcpTcp" {
  name                        = "master-ocp-tcp"
  priority                    =  600
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range          = "8053"
  destination_port_range      = "8053"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift TCP DNS and fluentd"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}

resource "azurerm_network_security_rule" "masterNsgOcpUdp" {
  name                        = "master-ocp-udp"
  priority                    =  625
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range          = "8053"
  destination_port_range      = "8053"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift UDP DNS and fluentd"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}


resource "azurerm_network_security_rule" "masterNsgKubelet" {
  name                        = "master-node-kubelet"
  priority                    =  650
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range          = "10250"
  destination_port_range      = "10250"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift kubelet"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]

}

resource "azurerm_network_security_rule" "masterNsgSdn" {
  name                        = "master-node-sdn"
  priority                    =  675
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range          = "4789"
  destination_port_range      = "4789"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  description                 = "Openshift sdn"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}

resource "azurerm_network_security_rule" "masterDenyAll" {
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
  network_security_group_name = "${azurerm_network_security_group.masterNsg.name}"
  
}