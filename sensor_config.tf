module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor"

  fleet_community_string                       = var.community_string
  sensor_license                               = var.license_key
  sensor_management_interface_name             = "eth0"
  sensor_monitoring_interface_name             = "eth1"
  sensor_health_check_probe_source_ranges_cidr = azurerm_subnet.subnet.address_prefixes
  sensor_health_check_http_port                = var.health_check_port
  gzip_config                                  = true
  base64_encode_config                         = true
  enrichment_enabled                           = var.enrichment_storage_account_name != "" && var.enrichment_storage_container_name != ""
  enrichment_cloud_provider_name               = "azure"
  enrichment_storage_account_name              = var.enrichment_storage_account_name
  enrichment_bucket_name                       = var.enrichment_storage_container_name
}