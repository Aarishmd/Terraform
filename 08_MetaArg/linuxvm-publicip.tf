# resource "azurerm_public_ip" "publicip" {
#   count = var.web_linuxvm_instance_count
#   name                = "${local.resource_name_prefix}-publicip-${count.index}"
#   resource_group_name = azurerm_resource_group.MyRG.name
#   location            = azurerm_resource_group.MyRG.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
# }

