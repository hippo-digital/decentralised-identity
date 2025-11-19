resource "azurerm_log_analytics_workspace" "did-app-log-workspace" {
  name                = "did-app-log-workspace"
  location            = azurerm_resource_group.did-app-rg
  resource_group_name = azurerm_resource_group.did-app-rg
  sku                 = "PerGB2018"
  retention_in_days   = 7
}
resource "azurerm_application_insights" "did-app-insights" {
  name                = "did-app-insights"
  location            = azurerm_resource_group.did-app-rg.location
  resource_group_name = azurerm_resource_group.did-app-rg.name
  application_type    = "web"
  workspace_id = azurerm_log_analytics_workspace.did-app-log-workspace.id
}