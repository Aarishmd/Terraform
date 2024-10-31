resource "azurerm_network_interface" "nic" {
  count = var.web_linuxvm_instance_count
  name                = "${local.resource_name_prefix}-nic-${count.index}"    #need 5 name for new resources 
  resource_group_name = azurerm_resource_group.MyRG.name
  location            = azurerm_resource_group.MyRG.location

  ip_configuration {
    name                          = "web-linuxvm-ip-${count.index}"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = element(azurerm_public_ip.publicip[*].id, count.index)
  }

}

