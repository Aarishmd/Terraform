# #This is the Public IP address for the LB
# resource "azurerm_public_ip" "web_lbpublicip" {
#   count = var.web_linuxvm_instance_count
#   name                = "${local.resource_name_prefix}-lbpublicIP-${count.index}"
#   resource_group_name = azurerm_resource_group.MyRG.name
#   allocation_method   = "Static"
#   location            = azurerm_resource_group.MyRG.location
#   sku                 = "Standard"
#   tags                = local.common_tags
# }

# # This is the defination of LB
# resource "azurerm_lb" "web_lb" {
#   count = var.web_linuxvm_instance_count
#   name                = "${local.resource_name_prefix}-web-lb${count.index}"
#   location            = azurerm_resource_group.MyRG.location
#   resource_group_name = azurerm_resource_group.MyRG.name
#   sku                 = "Standard"
#   frontend_ip_configuration {
#     name                 = "web-lb-ip01-${count.index}"
#     public_ip_address_id = azurerm_public_ip.web_lbpublicip[count.index].id
#   }
# }


# #Backend Assocaite with the LB 
# resource "azurerm_lb_backend_address_pool" "web_lb_backend" {
#   name            = "web-lb-backend"
#   loadbalancer_id = azurerm_lb.web_lb[0].id
# }

# #Backend Rule for Backend pool
# resource "azurerm_lb_probe" "web_lb_probe" {
#   name            = "tcp-probe"
#   protocol        = "Tcp"
#   port            = 80
#   loadbalancer_id = azurerm_lb.web_lb[0].id
# }

# #Create the NAT rule for LB
# resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_22" {
#   depends_on = [azurerm_virtual_machine.web_linux]
#   count = var.web_linuxvm_instance_count
#   name                           = "vm-${count.index}-ssh-${var.lb_inbound_nat_ports[count.index]}-22"
#   resource_group_name            = azurerm_resource_group.MyRG.location
#   loadbalancer_id                = azurerm_lb.web_lb[0].id
#   protocol                       = "Tcp"
#   frontend_port                  = element(var.lb_inbound_nat_ports, count.index)
#   backend_port                   = 22
#   frontend_ip_configuration_name = azurerm_lb.web_lb[count.index].frontend_ip_configuration[0].name
# }



# # Resource-5: Create LB Rule
# resource "azurerm_lb_rule" "web_lb_rule" {
#   name                           = "web-app1-rule"
#   protocol                       = "Tcp"
#   frontend_port                  = element(var.lb_inbound_nat_ports, count.index)
#   backend_port                   = 80
#   frontend_ip_configuration_name = azurerm_lb.web_lb[count.index].frontend_ip_configuration[0].name # Changed from name to id
#   probe_id                       = azurerm_lb_probe.web_lb_probe.id                    # Added health probe
#   loadbalancer_id                = azurerm_lb.web_lb[0].id
# }



# #Assocaite the NIC of VM to the Standard Load balancer 
# # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association

# resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
#   network_interface_id    = element(azurerm_network_interface.nic[*].id, count.index)
#   ip_configuration_name   = azurerm_network_interface.nic[count.index].ip_configuration[0].name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend.id
# }


# # Associate LB NAT Rule and VM Network Interface
# resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
#   count = var.web_linuxvm_instance_count
#   network_interface_id  = element(azurerm_network_interface.nic[*].id, count.index)
#   ip_configuration_name = azurerm_network_interface.nic[count.index].ip_configuration[0].name
#   nat_rule_id           = element(azurerm_lb_nat_rule.web_lb_inbound_nat_22[*].id, count.index)
# }

