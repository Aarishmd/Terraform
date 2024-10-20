
#This is the Public IP address for the LB
resource "azurerm_public_ip" "web_lbpublicip" {
  name                = "${local.resource_name_prefix}-lbpublicIP"
  resource_group_name = azurerm_resource_group.MyRG.name
  allocation_method   = "Static"
  location            = azurerm_resource_group.MyRG.location
  sku                 = "Standard"
  tags                = local.common_tags
}

# This is the defination of LB
resource "azurerm_lb" "web_lb" {
  name                = "${local.resource_name_prefix}-web-lb"
  location            = azurerm_resource_group.MyRG.location
  resource_group_name = azurerm_resource_group.MyRG.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "web-lb-ip01"
    public_ip_address_id = azurerm_public_ip.web_lbpublicip.id
  }
}


#Backend Assocaite with the LB 
resource "azurerm_lb_backend_address_pool" "web_lb_backend" {
  name            = "web-lb-backend"
  loadbalancer_id = azurerm_lb.web_lb.id
}

#Backend Rule for Backend pool
resource "azurerm_lb_probe" "web_lb_probe" {
  name            = "tcp-probe"
  protocol        = "Tcp"
  port            = 80
  loadbalancer_id = azurerm_lb.web_lb.id
}


# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "web_lb_rule" {
  name                           = "web-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name # Changed from name to id
  probe_id                       = azurerm_lb_probe.web_lb_probe.id                    # Added health probe
  loadbalancer_id                = azurerm_lb.web_lb.id
}



#Assocaite the NIC of VM to the Standard Load balancer 
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id    = azurerm_network_interface.nic.id
  ip_configuration_name   = azurerm_network_interface.nic.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend.id
}


