module "sensor_config" {
  source = "github.com/corelight/terraform-config-sensor?ref=v1.0.0"

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
  sensor_health_check_http_port                = local.monitoring_health_check_port
  subnetwork_monitoring_gateway                = cidrhost(data.azurerm_subnet.mon_subnet.address_prefixes[0], 1)
  subnetwork_monitoring_cidr                   = data.azurerm_subnet.mon_subnet.address_prefix
  gzip_config                                  = true
  base64_encode_config                         = true
}
