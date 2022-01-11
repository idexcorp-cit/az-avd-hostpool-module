# AVD Hostpool
resource "azurerm_virtual_desktop_host_pool" "avd" {
    name                = "${var.resource_prefix}-hostpool"
    friendly_name       = var.friendly_name != null ? "${var.friendly_name} Hostpool" : null
    
    resource_group_name = azurerm_resource_group.avd.name
    location            = azurerm_resource_group.avd.location

    type                                = "Personal"
    load_balancer_type                  = "Persistent"
    personal_desktop_assignment_type    = "Direct"
    validate_environment                = false
    start_vm_on_connect                 = true

    tags = var.tags

    lifecycle {
        ignore_changes = [
            registration_info
        ]
    }
}

output "hostpool_id" {
    value = azurerm_virtual_desktop_host_pool.avd.id
}

output "hostpool_name" {
    value = azurerm_virtual_desktop_host_pool.avd.name
}

output "hostpool_type" {
    value = azurerm_virtual_desktop_host_pool.avd.type
}