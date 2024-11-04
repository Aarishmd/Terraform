#Business variable
variable "business_variable" {
  description = "this is the bisness specification"
  type        = string
  default     = "Azure"
}

#Env varibales
variable "Enviroment" {
  type    = string
  default = "DEV"
}

# Azure Resource Group Name 
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rg-default"
}

# Azure Resources Location
variable "resource_group_location" {
  description = "Region in which Azure Resources to be created"
  type        = string
  default     = "eastus2"
}


#Local Variables this is used to avoid the repeating names of the variables 

# Define Local Values in Terraform imp for naming porpose
locals {
  owners               = var.business_variable
  environment          = var.Enviroment
  resource_name_prefix = "${var.business_variable}-${var.Enviroment}"
  #name = "${local.owners}-${local.environment}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}


#Random name creator resource for naming purpose
resource "random_string" "random" {
  length  = 6
  upper   = false
  special = false
  numeric = false
}

# Web LB Inbout NAT Port for All VMs
variable "lb_inbound_nat_ports" {
  description = "Web LB Inbound NAT Ports List"
  type = list(string)
  default = ["1022", "2022", "3022", "4022", "5022"]
}

variable "lb_rule_ports" {
  type    = list(number)
  default = [8080, 8081 , 8082, 8083, 8084, 885] # Unique ports for LB rules
}
# Linux VM Input Variables Placeholder file.

# Web Linux VM Instance Count
variable "web_linuxvm_instance_count" {
  description = "Web Linux VM Instance Count"
  type = map(string)
  default = {
    "vm1" = "1022",
    "vm2" = "2022"
  }
}
