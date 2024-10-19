resource "azurerm_network_interface" "nic" {
   name = "${local.resource_name_prefix}-nic"
   resource_group_name = azurerm_resource_group.MyRG.name
   location = azurerm_resource_group.MyRG.location

     ip_configuration {
    name                          = "web-linuxvm-ip-1"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.publicip.id
}

}