resource "azurerm_service_plan" "did-app-plan" {
  name                = "did-app-service-plan"
  location            = azurerm_resource_group.did-app-rg.location
  resource_group_name = azurerm_resource_group.did-app-rg.name
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_linux_web_app" "did-app-service" {
  name                = "did-app-service"
  resource_group_name = azurerm_resource_group.did-app-rg.name
  location            = azurerm_service_plan.did-app-plan.location
  service_plan_id     = azurerm_service_plan.did-app-plan.id
  site_config {
    always_on = false
    application_stack {
      dotnet_version = "8.0"
    }
  }
}

resource "null_resource" "did-app-deploy" {
  provisioner "local-exec" {
    command = "cd ../.. && python3 configure_settings.py --tenantID=${var.tenant_id} --clientID=${var.client_id} --clientSecret=${var.client_secret} --didAuth=${var.did_auth} --credManifest=${var.cred_manifest} && dotnet publish ./AspNetCoreVerifiableCredentials.csproj --configuration Release --output ./deploy && cd deploy && zip -r ../myapp.zip * && cd .. && az webapp deploy --resource-group ${azurerm_linux_web_app.did-app-service.resource_group_name} --name ${azurerm_linux_web_app.did-app-service.name} --src-path ./myapp.zip --type zip"
} 
  depends_on = [azurerm_linux_web_app.did-app-service]
}


output "did_app_service_url" {
  value = "https://${azurerm_linux_web_app.did-app-service.default_hostname}/"
}