locals {
  # https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview#probe-source-ip-address
  azure_lb_health_check_probe_ip = "168.63.129.16/32"
}

module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor?ref=v0.3.0"

  fleet_community_string                       = var.community_string
  fleet_token                                  = var.fleet_token
  fleet_url                                    = var.fleet_url
  fleet_server_sslname                         = var.fleet_server_sslname
  fleet_http_proxy                             = var.fleet_http_proxy
  fleet_https_proxy                            = var.fleet_https_proxy
  fleet_no_proxy                               = var.fleet_no_proxy
  sensor_license                               = var.license_key
  sensor_management_interface_name             = "eth0"
  sensor_monitoring_interface_name             = "eth1"
  sensor_health_check_probe_source_ranges_cidr = [local.azure_lb_health_check_probe_ip]
  gzip_config                                  = true
  base64_encode_config                         = true
  enrichment_enabled                           = var.enrichment_storage_account_name != "" && var.enrichment_storage_container_name != ""
  enrichment_cloud_provider_name               = "azure"
  enrichment_storage_account_name              = var.enrichment_storage_account_name
  enrichment_bucket_name                       = var.enrichment_storage_container_name
}
