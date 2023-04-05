output "web_app_default_hostname" {
  description = "Default hostname of the Linux Web App"
  value       = azurerm_linux_web_app.example.default_hostname
}

output "web_app_id" {
  description = "ID of the Linux Web App"
  value       = azurerm_linux_web_app.example.id
}