# Resource-1: Create Azure Standard Load Balancer
resource "azurerm_lb" "app_lb" {
  name                = "${local.resource_name_prefix}-app-lb"
  location            = azurerm_resource_group.MyRG.location
  resource_group_name = azurerm_resource_group.MyRG.name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "app-lb-privateip-1"
    subnet_id = azurerm_subnet.appsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address_version = "IPv4"
    private_ip_address = "10.0.11.56"
  }
}
 
# Resource-3: Create LB Backend Pool
resource "azurerm_lb_backend_address_pool" "app_lb_backend_address_pool" {
  name                = "app-backend"
  loadbalancer_id     = azurerm_lb.app_lb.id
}

# Resource-4: Create LB Probe
resource "azurerm_lb_probe" "app_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 80
  loadbalancer_id     = azurerm_lb.app_lb.id

}

# Resource-5: Create LB Rule
resource "azurerm_lb_rule" "app_lb_rule_app1" {
  name                           = "app-app1-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.app_lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.app_lb_probe.id
  loadbalancer_id                = azurerm_lb.app_lb.id
}
