# Azure Virtual Desktop Personal Hostpool Module
![GitHub commits since latest release (by date)](https://img.shields.io/github/commits-since/idexcorp-cit/az-avd-personal-hostpool-module/latest/main)

This Terraform module is designed to deploy an Azure Virtual Desktop Hostpool with Personal Desktops. This can be used in conjunction with the [az-avd-personal-host-module](https://github.com/idexcorp-cit/az-avd-personal-host-module) and [az-avd-hostpool-token-module](https://github.com/idexcorp-cit/az-avd-hostpool-token-module) modules.

This module will have the following attributes output:
- `hostpool_id` - ID of the Hostpool
- `hostpool_name` - Name of the Hostpool
- `hostpool_type` - Type of Hostpool created (Personal)
- `dag_id` - ID of the Desktop Application Group
- `resource_group_id` - ID of Hostpool's Resource Group
- `resource_group_name` - Name of Hostpool's Resource Group
- `resource_group_location` - Location of Hostpool's Resource Group

Here is an example:
```terraform
module "hostpool" {
    source              = "git::https://github.com/idexcorp-cit/az-avd-personal-hostpool-module.git?ref=v0.1.0"

    resource_prefix = "eus-avd"
    location        = "eastus"
    friendly_name   = "East US AVD"
    
    tags = var.common_tags
}

module "hostpool_token" {
    source                  = "git::https://github.com/idexcorp-cit/az-avd-hostpool-token-module.git?ref=v0.1.0"

    hostpool_resource_group = module.hostpool.resource_group_name
    hostpool_name           = module.hostpool.hostpool_name
    token_valid_hours       = 3
}

resource "azurerm_resource_group" "avd_host" {
    for_each    = var.avd_users

    name        = "eus-avd-${each.key}-rg"
    location    = module.hostpool.resource_group_location

    tags = merge(
        tomap({"avd_user" = lookup(each.value, "user")}),
        var.common_tags
    )
}

module "host" {
    source                  = "git::https://github.com/idexcorp-cit/az-avd-personal-host-module.git?ref=v0.1.0"

    for_each                = var.avd_users

    resource_prefix         = "eus-avd-${each.key}"
    resource_group_name     = azurerm_resource_group.avd_host[each.key].name
    location                = azurerm_resource_group.avd_host[each.key].location
    hostpool_name           = module.hostpool.hostpool_name
    hostpool_token          = module.hostpool_token.token
    hostpool_resource_group = module.hostpool.resource_group_name
    dag_id                  = module.hostpool.dag_id
    host_subnet_id          = var.subnet_id
    host_encryption_at_host = true
    
    adds_domain_join_upn    = var.adds_domain_join_upn
    adds_domain_join_pass   = var.adds_domain_join_pass
    adds_domain_join_name   = var.adds_domain_join_name
    adds_ou_path            = var.adds_ou_path

    assigned_user       = lookup(each.value, "user")
    host_computer_name  = lookup(each.value, "computer_name_override", "avd${substr(var.department_shortname, 0, 3)}${substr(each.key, 0, 7)}")
    host_index          = lookup(each.value, "index")
    host_size           = lookup(each.value, "size", "Standard_D2s_v4")
    host_disk_size      = lookup(each.value, "disk_size", "256")
    host_timezone       = lookup(each.value, "timezone", "Eastern Standard Time")
    host_image_offer    = lookup(each.value, "image_offer", "Windows-10")
    host_image_sku      = lookup(each.value, "image_sku", "win10-21h2-ent")
    host_shutdown_time  = lookup(each.value, "shutdown_time", null)
}
```