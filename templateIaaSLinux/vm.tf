resource "azurerm_network_interface" "main" {
  count = "${var.isLinux ? 1 : 0}"
  name                = "NIC${var.vm_name}_1"
  location            = "${var.location}"
  resource_group_name = "${var.rgname}"

  dns_servers= "${var.dns_servers}"

  ip_configuration {
    name                          = "NIC${var.vm_name}_1_CONF"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
  }

}
resource "azurerm_virtual_machine" "main" {
  count = "${var.isLinux ? 1 : 0}"
  name                  = "${var.vm_name}"
  location            = "${var.location}"
  resource_group_name = "${var.rgname}"
  network_interface_ids = ["${element(azurerm_network_interface.main.*.id, count.index)}"]
  vm_size               = "${var.vm_size}"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${var.image_id}"
  }
  storage_os_disk {
    name              = "${var.vm_name}_OS_DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

   storage_data_disk {
    name              = "${var.vm_name}_DATA_DISK_1"
    lun = "0"
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "${var.data_disk_size}"
  }
  os_profile {
    computer_name  = "${var.vm_name}"
    admin_username = "clou_usr"
    admin_password = "${var.password}"
  }
  
  os_profile_linux_config {
    disable_password_authentication = false
  }

 boot_diagnostics {
    enabled = true
    storage_uri = "${var.storage_uri}"
  }

  tags = "${var.tags}"
}

# resource "azurerm_virtual_machine_extension" "main" {
#   count = "${var.isLinux ? 1 : 0}"
#   name                       = "${element(azurerm_virtual_machine.main.*.name, count.index)}-OMS"
#   location                   = "${var.location}"
#   resource_group_name        = "${var.rgname}"
#   virtual_machine_name       = "${element(azurerm_virtual_machine.main.*.name, count.index)}"
#   publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
#   type                       = "OmsAgentForLinux"
#   type_handler_version       = "1.7"
#   auto_upgrade_minor_version = false
# }