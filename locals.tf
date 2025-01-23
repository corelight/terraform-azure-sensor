locals {
  monitoring_subnet_resource_id_slice = split("/", var.monitoring_subnet_id)
  monitoring_subnet_name      = local.monitoring_subnet_resource_id_slice[length(local.monitoring_subnet_resource_id_slice) - 1]
  monitoring_subnet_vnet_name = local.monitoring_subnet_resource_id_slice[8]

  monitoring_health_check_port = 41080

  # https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-custom-probe-overview#probe-source-ip-address
  azure_lb_health_check_probe_ip = "168.63.129.16/32"
}