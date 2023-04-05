# Generate a random string to create a unique name
resource "random_string" "id" {
  length  = 4
  lower   = true
  numeric = true
  special = false
  upper   = false
}

# create a resource group
resource "azurerm_resource_group" "example" {
  name     = "rg-example-${random_string.id.result}"
  location = "eastus"
}

# App Service plan - manages an App Service: Service Plan.
resource "azurerm_service_plan" "example" {
  name                = "plan-example-${random_string.id.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux" #The O/S type for the App Services to be hosted in this plan. Other values inlcude Windows and WindowsContainer
  sku_name            = "B1" # Free SKU plan
}

# App Service - Manages a Linux Web App. Creates the web app. Passes in the App Service Plan ID
resource "azurerm_linux_web_app" "example" {
  name                = "webapp-calculator-${random_string.id.result}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  service_plan_id     = azurerm_service_plan.example.id #The ID of the Service Plan that this Linux App Service will be created in.
  https_only          = true #Should the Linux Web App require HTTPS connections.

  site_config {
    always_on         = false #always_on must be explicitly set to false when using free service plans
    use_32_bit_worker = true

    application_stack {
      node_version = "16-lts"
    }
  }
}

# Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "example" {
  app_id                 = azurerm_linux_web_app.example.id
  repo_url               = var.repo_url
  branch                 = var.repo_branch
  use_manual_integration = true
  use_mercurial          = false
}