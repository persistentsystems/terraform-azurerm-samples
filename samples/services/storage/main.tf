locals {
  context = {
    event_delivery_schema = null
    topic_name            = null
    labels                = null
    filters               = null
    eventhub_id           = null
    service_bus_topic_id  = null
    service_bus_queue_id  = null
    included_event_types  = null
  }

module "storage" {
  source  = "github.com/persistentsystems/terraform-azurerm/services/resource-group/base/v1"

  context = local.context
  name = "storage-foo"
}

resource "azurerm_storage_account" "storage" {
  name                      = format("%s%ssa", lower(replace(var.name, "/[[:^alnum:]]/", "")), random_string.unique.result)
  resource_group_name       = azurerm_resource_group.storage.name
  location                  = azurerm_resource_group.storage.location
  account_kind              = "StorageV2"
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = true

  blob_properties {
    delete_retention_policy {
      days = var.soft_delete_retention
    }
  }

  resource "azurerm_storage_container" "storage" {
  count                 = length(var.containers)
  name                  = var.containers[count.index].name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.containers[count.index].access_type
}