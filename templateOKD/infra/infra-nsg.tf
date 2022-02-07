


resource "azurerm_network_security_group" "infraNsg" {
  name                = "NSG${var.cluster_name}INFRA"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
}

resource "azurerm_network_security_rule" "infraNsgSSH" {
  name                        = "infra-ssh"
  priority                    = 500
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
  description                 = "Openshift SSH from the bastions"
  source_address_prefix = "${var.bastion_ip}"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "infraNsgRouter" {
  name                        = "infra-router-ports"
  priority                    = 525
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_port_ranges     = ["80","443"]
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
  description                 = "Openshift router"
  destination_address_prefix = "*"
}

resource "azurerm_network_security_rule" "infraNsgPorts" {
  name                        = "infra-ports"
  priority                    = 550
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9200", "9300" ]
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
  description                 = "Openshift ElasticSearch"
  destination_address_prefix = "*"
  source_address_prefix       = "*"
}

resource "azurerm_network_security_rule" "infraNsgKubelet" {
  name                        = "infra-node-kubelet"
  priority                    =  575
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  destination_port_range      = "10250"
  source_port_range           = "*"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
  description                 = "Openshift kubelet"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
}


resource "azurerm_network_security_rule" "infraNsgSdn" {
  name                        = "infra-node-sdn"
  priority                    =  600
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "4789"
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
  description                 = "Openshift Sdn"
  source_application_security_group_ids = ["${var.asg_id}"]
  destination_application_security_group_ids = ["${var.asg_id}"]
  
}

resource "azurerm_network_security_rule" "infraNsgRouter-2" {
  name                        = "infra-router-ports-2"
  priority                    = 625
  direction                   = "Inbound"
  access                      = "Allow"
  source_port_range           = "*"
  protocol                    = "Tcp"
  destination_port_ranges      = ["80","443"]
  resource_group_name         = "${var.rg_name}"
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
  description                 = "Openshift router ports"
  source_address_prefix       = "*"
  destination_address_prefix = "*"
}


resource "azurerm_network_security_rule" "infraDenyAll" {
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
  network_security_group_name = "${azurerm_network_security_group.infraNsg.name}"
}