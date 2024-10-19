resource "azurerm_virtual_machine" "web_linux" {
   name                  = "${local.resource_name_prefix}-web-linuxvm"
   resource_group_name   = azurerm_resource_group.MyRG.name
   location              = azurerm_resource_group.MyRG.location
   network_interface_ids = [azurerm_network_interface.nic.id]
   vm_size               = "Standard_DS1_v2"

   # Use a Linux image from RedHat
   storage_image_reference {
       publisher = "RedHat"
       offer     = "RHEL"
       sku       = "83-gen2"
       version   = "latest"
   }

   # Define the OS disk
   storage_os_disk {
       name          = "myosdisk1"
       caching       = "ReadWrite"
       create_option = "FromImage"
       managed_disk_type = "Standard_LRS" # Use a managed disk
   }


   # Set up OS profile for Linux VM
   os_profile {
       computer_name  = "web-linux-vm"
       admin_username = "azureuser"
       admin_password = "Password1234!" # You can also use SSH keys here instead of password
   }

   # Configure Linux-specific settings (e.g., SSH)
   os_profile_linux_config {
       disable_password_authentication = false # Set true if you prefer SSH keys
   }

   # Tags (optional, but good for resource management)
   tags = {
       environment = "Production"
       department  = "IT"
   }
}


