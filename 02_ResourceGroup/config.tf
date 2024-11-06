# Provider Default Provider
provider "azurerm" {
  features {}
  subscription_id = "92882f0b-81c9-4214-8f4b-115816a1938a"
}

# Provider-2 for WestUS Region
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false # This will ensure when the Virtual Machine is destroyed, Disk is not deleted, default is true and we can alter it at provider level
    }
  }
  subscription_id = "92882f0b-81c9-4214-8f4b-115816a1938a"
  alias = "provider2-westus"
}

