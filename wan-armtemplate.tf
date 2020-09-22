#############################################################################
# PROVIDERS
#############################################################################
provider "azurerm" {
  features {}
  version         = ">2.21.0"
  subscription_id = "xxxxxxxxxxxxxxxxxxxx"
}

variable "resource_group_name" {
  type        = string
  description = "name of resource group"
  default     = "rg-azdemo-vwan"
}

#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_template_deployment" "vwan" {
  name                = "azvwandeployment01"
  resource_group_name = var.resource_group_name

  template_body = file("azuredeployhub.json")

  parameters = {
    "wanName" = "azwan-demo01"
    "hubname" = "us-hub01"
  }

  deployment_mode = "Incremental"
}
