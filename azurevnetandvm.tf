provider "azurerm" {
  features {}
  version         = ">2.21.0"
  subscription_id = "dead8329-b12b-4816-8b97-943531d50a18"
}

#create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-azdemo-vwan"
  location = "australiasoutheast"
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

# Create a virtual network in India West region 

resource "azurerm_virtual_network" "indwvnet" {

  name                = "indw-vnet01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "westindia"
  address_space       = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "indwsubnet" {
  name                 = "workload-indw01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.indwvnet.name
  address_prefixes     = ["10.1.0.0/24"]
}
#create Public ip in Australia east region

resource "azurerm_public_ip" "auepip" {
  name                = "auevmpip01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  allocation_method   = "Static"
}
# Create public IP in Australia east region 
resource "azurerm_public_ip" "auepip" {
  name                = "auevm-pip01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create a virtual Machine Nic in Australia east region 
resource "azurerm_network_interface" "auenic" {
  name                = "auevm-nic01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "aueinternal"
    subnet_id                     = azurerm_subnet.ausesubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.auepip.id
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
    azurerm_network_interface.auenic.id,
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