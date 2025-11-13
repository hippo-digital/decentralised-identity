resource "azurerm_app_service_plan" "did-app-plan" {
  name                = "did-app-service-plan"
  location            = azurerm_resource_group.did-app-rg.location
  resource_group_name = azurerm_resource_group.did-app-rg.name
  kind                = "Linux"

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "did-app-service" {
  name                = "did-app-service"
  location            = azurerm_resource_group.did-app-rg.location
  resource_group_name = azurerm_resource_group.did-app-rg.name
  app_service_plan_id = azurerm_app_service_plan.did-app-plan.id

  site_config {
    dotnet_framework_version = "v8.0"
    scm_type                 = "None"
  }

  # app_settings = {
  #   "TENANT_ID" = "some-value"
  #   "CRED_MANIFEST" = "some-value"
  #   "CLIENT_SECRET" = "some-value"
  #   "CLIENT_ID" = "some-value"
  #   "DID_AUTH" = "some-value"
  # }
}