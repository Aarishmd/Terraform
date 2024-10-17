resource "azurerm_public_ip" "publicip" {
   name = "${local.resource_name_prefix}-publicip"
   resource_group_name = azurerm_resource_group.MyRG.name
   location = azurerm_resource_group.MyRG.location
   allocation_method = "Static"
   sku = "Standard"
}

