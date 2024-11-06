resource "azurerm_resource_group" "Rg02" {
 name = "rg02"
 location= "West US" 
 provider = azurerm.provider2-westus
}

resource "random_string" "myrandom" {
  length = 16
  special = false
  upper = false
}

resource "azurerm_storage_account" "Stoarge" {
   name = "mystorage${random_string.myrandom.lower}"
   resource_group_name = azurerm_resource_group.Rg02.name
   location = azurerm_resource_group.Rg02.location
   account_tier = "Standard"
   account_replication_type = "GRS"
   tags = {
    env: "Staging"
   }
}

