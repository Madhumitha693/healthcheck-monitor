provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "healthcheck-rg"
  location = "East US"
}

resource "azurerm_container_registry" "acr" {
  name                = "healthcheckacr123" # must be unique globally
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "healthcheck-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "healthcheck"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}
output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
