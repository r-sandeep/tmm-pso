
resource "azurerm_network_interface" "infra" {
  count               = "${var.replicas}"
  name                = "NICVMINFRA${format("%02d", count.index+1)}${var.cluster_name}"
  location            = "${var.rg_location}"
  resource_group_name = "${var.rg_name}"
  //network_security_group_id = "${azurerm_network_security_group.infraNsg.id}"
  

  ip_configuration {
    name                          = "DIPVMINFRA${format("%02d", count.index+1)}${var.cluster_name}"
    subnet_id                     = "${var.subnet}"
    application_security_group_ids = ["${var.asg_id}"]
    private_ip_address_allocation = "Dynamic"

    // For test pourpose only
    //private_ip_address_allocation = "Static"
    //private_ip_address="10.244.253.112"
  }

  dns_servers =  [ "10.248.158.8", "10.248.177.61", "10.248.176.61"]
}

resource "azurerm_network_interface_application_security_group_association" "infra" {
  count = "${var.replicas}"
  network_interface_id          = "${element(azurerm_network_interface.infra.*.id, count.index)}"
  ip_configuration_name         = "DIPVMINFRA${format("%02d", count.index+1)}${var.cluster_name}"
  application_security_group_id = "${var.asg_id}"
}

resource "azurerm_network_interface_backend_address_pool_association" "infra"{
  count = "${var.replicas}"
  network_interface_id    = "${element(azurerm_network_interface.infra.*.id, count.index)}"
  ip_configuration_name   = "DIPVMINFRA${format("%02d", count.index+1)}${var.cluster_name}"
  backend_address_pool_id = "${var.lb_id}"
}
resource "azurerm_virtual_machine" "infra" {
  count                 = "${var.replicas}"
  name                  = "vminfra${format("%02d", count.index+1)}${lower(var.cluster_name)}"
  location              = "${var.rg_location}"
  resource_group_name   = "${var.rg_name}"
  network_interface_ids = ["${element(azurerm_network_interface.infra.*.id, count.index)}"]
  vm_size               = "Standard_D2_v3"

  delete_os_disk_on_termination = true


  delete_data_disks_on_termination = true

  availability_set_id   = "${azurerm_availability_set.infra.id}"

  storage_image_reference {
    id = "/subscriptions/fbf7e6d4-cf46-4b1b-a1a3-17c98dd81fd8/resourceGroups/test_cluster_origin/providers/Microsoft.Compute/images/originpoc-image-centoslvm-02"
  }
  storage_os_disk {
    name              = "VMINFRA${format("%02d", count.index+1)}${var.cluster_name}_OS_DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vminfra${format("%02d", count.index+1)}${lower(var.cluster_name)}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
          acronimo = "PROT0"
          environment = "PoC"
          origin-role = "infra"
          cluster-origin = "${var.cluster_name}"
        }
}
