resource "azurerm_virtual_desktop_workspace" "avd" {
    name                = "${var.resource_prefix}-workspace"
    resource_group_name = azurerm_resource_group.avd.name
    location            = azurerm_resource_group.avd.location

    friendly_name       = var.friendly_name != null ? "${var.friendly_name} Workspace" : null

    tags = var.tags
}

# Associate the DAG to the workspace
resource "azurerm_virtual_desktop_workspace_application_group_association" "avd" {
    workspace_id            = azurerm_virtual_desktop_workspace.avd.id
    application_group_id    = azurerm_virtual_desktop_application_group.desktop.id
}