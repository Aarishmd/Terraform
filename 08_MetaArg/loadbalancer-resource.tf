# Public IP for the Load Balancer
resource "azurerm_public_ip" "web_lbpublicip" {
  count                = var.web_linuxvm_instance_count
  name                 = "${local.resource_name_prefix}-lbpublicIP-${count.index}"
  resource_group_name  = azurerm_resource_group.MyRG.name
  allocation_method    = "Static"
  location             = azurerm_resource_group.MyRG.location
  sku                  = "Standard"
  tags                 = local.common_tags
}

# Load Balancer definition
resource "azurerm_lb" "web_lb" {
  name                 = "${local.resource_name_prefix}-Common-lb"
  location             = azurerm_resource_group.MyRG.location
  resource_group_name  = azurerm_resource_group.MyRG.name
  sku                  = "Standard"
  
  frontend_ip_configuration {
    name                 = "Common-lb-ip"
    public_ip_address_id = azurerm_public_ip.web_lbpublicip[0].id
  }
}

# Backend Pool associated with the Load Balancer
resource "azurerm_lb_backend_address_pool" "web_lb_backend" {
  count            = var.web_linuxvm_instance_count
  name             = "lb-backend-${count.index}"
  loadbalancer_id  = azurerm_lb.web_lb.id
}

# Health Probe for Backend Pool
resource "azurerm_lb_probe" "web_lb_probe" {
  count            = var.web_linuxvm_instance_count
  name             = "tcp-probe-${count.index}"
  protocol         = "Tcp"
  port             = 80
  loadbalancer_id  = azurerm_lb.web_lb.id
}

# NAT Rule for Load Balancer
resource "azurerm_lb_nat_rule" "web_lb_inbound_nat_22" {
  count                          = var.web_linuxvm_instance_count
  name                           = "vm-${count.index}-ssh-${var.lb_inbound_nat_ports[count.index]}-22"
  resource_group_name            = azurerm_resource_group.MyRG.name
  loadbalancer_id                = azurerm_lb.web_lb.id
  protocol                       = "Tcp"
  frontend_port                  = var.lb_inbound_nat_ports[count.index]
  backend_port                   = 22
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
}

# Load Balancer Rule
resource "azurerm_lb_rule" "web_lb_rule" {
  count                          = var.web_linuxvm_instance_count
  name                           = "web-app1-rule-${count.index}"
  protocol                       = "Tcp"
  frontend_port                  = var.lb_rule_ports[count.index]
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.web_lb_probe[count.index].id
  loadbalancer_id                = azurerm_lb.web_lb.id
}

# Associate NIC with Backend Pool of Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  count                       = var.web_linuxvm_instance_count
  network_interface_id        = azurerm_network_interface.nic[count.index].id
  ip_configuration_name       = azurerm_network_interface.nic[count.index].ip_configuration[0].name
  backend_address_pool_id     = azurerm_lb_backend_address_pool.web_lb_backend[count.index].id
}

# Associate NAT Rule with NIC
resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
  count                      = var.web_linuxvm_instance_count
  network_interface_id       = azurerm_network_interface.nic[count.index].id
  ip_configuration_name      = azurerm_network_interface.nic[count.index].ip_configuration[0].name
  nat_rule_id                = azurerm_lb_nat_rule.web_lb_inbound_nat_22[count.index].id
}
