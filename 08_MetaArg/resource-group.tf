resource "azurerm_resource_group" "MyRG" {
  name     = "${local.resource_name_prefix}_${var.resource_group_name}_${random_string.random.id}"
  location = var.resource_group_location
  tags     = local.common_tags
}