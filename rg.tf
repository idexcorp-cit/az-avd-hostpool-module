resource "azurerm_resource_group" "avd" {
    name        = "${var.resource_prefix}-avd-rg"
    location    = var.location

    tags = var.tags != null ? var.tags : null
}

output "resource_group_id" {
    value = azurerm_resource_group.avd.id
}

output "resource_group_name" {
    value = azurerm_resource_group.avd.name
}

output "resource_group_location" {
    value = azurerm_resource_group.avd.location
}