provider "azurerm" {
  features {}
  version         = ">2.21.0"
  subscription_id = "xxxxxxxxxxxx"
}

#create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-azdemo-vwan"
  location = "australiasoutheast"
}

# Create a virtual network in Australia Southeast region

resource "azurerm_virtual_network" "ausevnet" {

  name                = "ause-vnet01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "auesubnet" {
  name                 = "workload-ause01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.ausevnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

# Create a virtual network in Australia East region

resource "azurerm_virtual_network" "auevnet" {

  name                = "aue-vnet01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  address_space       = ["10.2.0.0/24"]
}

resource "azurerm_subnet" "ausesubnet" {
  name                 = "workload-aue01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.auevnet.name
  address_prefixes     = ["10.2.0.0/24"]
}

# Create a virtual network in US West region 

resource "azurerm_virtual_network" "uewvnet" {

  name                = "usw-vnet01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westus"
  address_space       = ["10.3.0.0/24"]
}

resource "azurerm_subnet" "uewsubnet" {
  name                 = "workload-usw01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.uewvnet.name
  address_prefixes     = ["10.3.0.0/24"]
}
# Create a Azure Virtual WAN in Australia region 
/*
resource "azurerm_virtual_wan" "azwan" {
  name                           = "azdemo-wan"
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = azurerm_resource_group.rg.location
  type                           = "standard"
  allow_branch_to_branch_traffic = "true"
  allow_vnet_to_vnet_traffic     = "true"
}
*/
# Create a virtual Machine Nic in Australia South east region 
resource "azurerm_network_interface" "ausenic" {
  name                = "ausevm-nic01"
  location            = "australiasoutheast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "auseinternal"
    subnet_id                     = azurerm_subnet.ausesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create a virtual Machine in Australia South east region 
resource "azurerm_windows_virtual_machine" "ausevm" {
  name                = "ausedemo-vm01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiasoutheast"
  size                = "Standard_d2_v3"
  admin_username      = "kloudadmin"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.ausenic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-smalldisk"
    version   = "latest"
  }
}
# Create a virtual Machine Nic in Australia east region 
resource "azurerm_network_interface" "ausenic" {
  name                = "auevm-nic01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "aueinternal"
    subnet_id                     = azurerm_subnet.ausesubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create a virtual Machine in Australia east region 
resource "azurerm_windows_virtual_machine" "ausevm" {
  name                = "auedemo-vm01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  size                = "Standard_d2_v3"
  admin_username      = "kloudadmin"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.ausenic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
