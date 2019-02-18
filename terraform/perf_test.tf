variable "perf_test_rg" {
  default = "rdo-perftest-poc"
}
variable "perf_test_vm_name" {
  default = "rdo-perftest-poc-vm"
}
variable "perf_test_vm_count" {
    default = 1
}
variable "username" {
  default = "username"
}
variable "password" {
  default = "password"
}


terraform {
  required_version = ">= 0.11" 
  backend "azurerm" {}
}

data "azurerm_resource_group" "perf_test_rg" {
  name = "${var.perf_test_rg}"
}

data "azurerm_virtual_network" "perf_test_vnet" {
  name                = "rdo-perftest-poc-vnet"
  resource_group_name = "${data.azurerm_resource_group.perf_test_rg.name}"
}

data "azurerm_subnet" "perf_test_subnet" {
  name                      = "default"
  resource_group_name       = "${data.azurerm_resource_group.perf_test_rg.name}"
  virtual_network_name      = "${data.azurerm_virtual_network.perf_test_vnet.name}"
}

resource "azurerm_network_interface" "perf_test_nic" {
  name                      = "${var.perf_test_vm_name}-${format("%02d",count.index)}-nic"
  location                  = "${data.azurerm_resource_group.perf_test_rg.location}"
  resource_group_name       = "${data.azurerm_resource_group.perf_test_rg.name}"
  count                     = "${var.perf_test_vm_count}"

  ip_configuration {
    name                          = "${var.perf_test_vm_name}-${format("%02d",count.index)}-ip"
    subnet_id                     = "${data.azurerm_subnet.perf_test_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.perf_test_public_ip.*.id[count.index]}"
  }
}

resource "azurerm_public_ip" "perf_test_public_ip" {
  name                = "${var.perf_test_vm_name}-${format("%02d",count.index)}-pip"
  location            = "${data.azurerm_resource_group.perf_test_rg.location}"
  resource_group_name = "${data.azurerm_resource_group.perf_test_rg.name}"
  public_ip_address_allocation   = "static"
  count               = "${var.perf_test_vm_count}"
}

resource "azurerm_network_security_group" "perf_test_nsg" {
  name                = "${data.azurerm_resource_group.perf_test_rg.name}-nsg"
  location            = "${data.azurerm_resource_group.perf_test_rg.location}"
  resource_group_name = "${data.azurerm_resource_group.perf_test_rg.name}"
}

resource "azurerm_network_security_rule" "perf_test_nsg_rule_http" {
  name                        = "HTTP-in"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 80
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.perf_test_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.perf_test_nsg.name}" 
}

resource "azurerm_network_security_rule" "perf_test_nsg_rule_ssh" {
  name                        = "SSH-in"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${data.azurerm_resource_group.perf_test_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.perf_test_nsg.name}" 
}

resource "azurerm_virtual_machine" "perf_test_vm" {
  name                         = "${var.perf_test_vm_name}-${format("%02d",count.index)}"
  location                     = "${data.azurerm_resource_group.perf_test_rg.location}"
  resource_group_name          = "${data.azurerm_resource_group.perf_test_rg.name}" 
  network_interface_ids        = ["${azurerm_network_interface.perf_test_nic.*.id[count.index]}"]
  vm_size                      = "Standard_B1s"
  count                        = "${var.perf_test_vm_count}"

  storage_image_reference {
    publisher = "center-for-internet-security-inc"
    offer     = "cis-ubuntu-linux-1804-l1"
    sku       = "cis-ubuntu1804-l1"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.perf_test_vm_name}-${format("%02d",count.index)}-os"    
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  
  os_profile {
    computer_name      = "${var.perf_test_vm_name}-${format("%02d",count.index)}" 
    admin_username     = "${var.username}"
    admin_password     = "${var.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
    
    #ssh_keys {
    #  path          = "/home/${var.username}/.ssh/authorized_keys"
    #  key_data      = "${var.ssh_key}"
    # }
  }

  provisioner "remote-exec" {
    inline = [
    "sudo apt update && apt dist-upgrade -y",
    "sudo apt install -y libssl-dev libffi-dev python-dev python-pip",
    "sudo pip install ansible[azure]"
    ]
    connection {
      type        = "ssh"
      user        = "${var.username}"
      password    = "${var.password}"
      timeout     = "1m"
    }
  }

}

output "perf_test_vm_name" {
  value = ["${azurerm_virtual_machine.perf_test_vm.*.name}"]
}
