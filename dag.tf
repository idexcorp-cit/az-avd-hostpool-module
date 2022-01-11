resource "azurerm_virtual_desktop_application_group" "desktop" {
    name                = "${var.resource_prefix}-dag"
    resource_group_name = azurerm_resource_group.avd.name
    location            = azurerm_resource_group.avd.location

    type                = "Desktop"
    host_pool_id        = azurerm_virtual_desktop_host_pool.avd.id

    tags = var.tags
}

output "dag_id" {
    value = azurerm_virtual_desktop_application_group.desktop.id
}