#terraform
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0" # specify the desired version
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "92882f0b-81c9-4214-8f4b-115816a1938a"
  features {

  }
}

