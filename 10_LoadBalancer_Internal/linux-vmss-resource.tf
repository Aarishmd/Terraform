resource "azurerm_virtual_machine_scale_set" "web_vmss" {
   name = "${local.resource_name_prefix}-web_vmss"
   location = azurerm_resource_group.MyRG.location
   resource_group_name = azurerm_resource_group.MyRG.name
   upgrade_policy_mode = "Manual"

   sku {
       name = "Standard_DS1_V2"
       tier = "Standard"
       capacity = 3
   }

   os_profile {
       computer_name_prefix = "vmss-app1"
       admin_username = "myadmin"
       admin_password = "Passwword1234"
   }
   

   network_profile {
       name = "TestNetworkProfile"
       primary = true
        network_security_group_id = azurerm_network_security_group.web_vmss_nsg.id
       ip_configuration {
           name = "internal"
           subnet_id = azurerm_subnet.web_subnet.id
           load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.web_lb_backend.id]
           primary = true
       }
   }

   storage_profile_os_disk {
       caching       = "ReadWrite"
       create_option = "FromImage"
       managed_disk_type = "Standard_LRS"
   }

   storage_profile_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
   }

}


