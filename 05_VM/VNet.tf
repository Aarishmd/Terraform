resource "azurerm_virtual_network" "Vnet" {
   name = "${local.resource_name_prefix}-${var.vnet_name}"
   location = azurerm_resource_group.MyRG.location
   resource_group_name = azurerm_resource_group.MyRG.name
   tags = local.common_tags
   address_space = var.vnet_address
}