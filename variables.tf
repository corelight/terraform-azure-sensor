variable "location" {
  description = "The Azure location where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where corelight resources will be deployed"
  type        = string
}

variable "license_key" {
  description = "Your Corelight sensor license key"
  type        = string
  sensitive   = true
}

variable "management_subnet_id" {
  description = "The subnet used to access the sensor"
  type        = string
}

variable "monitoring_subnet_id" {
  description = "The subnet used for monitoring traffic"
  type        = string
}

variable "corelight_sensor_image_id" {
  description = "The resource id of Corelight sensor image"
  type        = string
}

variable "community_string" {
  type        = string
  sensitive   = true
  description = "the community string (api string) often times referenced by Fleet"
}

variable "sensor_ssh_public_key" {
  description = "The SSH public key which will be added to all sensors in the scale set"
  type        = string
}

## Variables with defaults
variable "sensor_admin_username" {
  description = "The name of the admin user on the corelight sensor VM in the VMSS"
  type        = string
  default     = "ubuntu"
}

variable "nat_gateway_ip_name" {
  description = "The resource name of the VMSS NAT Gateway public IP resource"
  type        = string
  default     = "cl-nat-gw-ip"
}

variable "nat_gateway_name" {
  description = "The resource name of the VMSS NAT Gateway resource"
  type        = string
  default     = "cl-sensor-nat-gw"
}

variable "autoscale_setting_name" {
  description = "The VMSS autoscale monitor name"
  type        = string
  default     = "corelight-scale-set-autoscale-cfg"
}

variable "load_balancer_name" {
  description = "The nane of the internal load balancer that sends traffic to the VMSS"
  type        = string
  default     = "corelight-sensor-lb"
}

variable "scale_set_name" {
  description = "Name of the Corelight VMSS of sensors"
  type        = string
  default     = "corelight-sensor"
}

variable "virtual_machine_size" {
  description = "The VMSS VM size"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "virtual_machine_os_disk_size" {
  description = "The amount of OS disk to attach to the VMSS instances"
  type        = number
  default     = 500
}

variable "enrichment_storage_account_name" {
  description = "(optional) the azure storage account where enrichment data is stored"
  type        = string
  default     = ""
}

variable "enrichment_storage_container_name" {
  description = "(optional) the container where enrichment data is stored"
  type        = string
  default     = ""
}

variable "lb_management_frontend_ip_config_name" {
  description = "Name of the internal load balancer management backend pool frontend ip configuration"
  type        = string
  default     = "corelight-management"
}

variable "lb_monitoring_frontend_ip_config_name" {
  description = "Name of the internal load balancer monitoring backend pool frontend ip configuration"
  type        = string
  default     = "corelight-monitoring"
}

variable "lb_mgmt_backend_address_pool_name" {
  description = "Name of the load balancer management backend address pool"
  type        = string
  default     = "management-pool"
}

variable "lb_mon_backend_address_pool_name" {
  description = "Name of the load balancer monitoring backend address pool"
  type        = string
  default     = "monitoring-pool"
}

variable "lb_monitoring_probe_name" {
  description = "Name of the load balancer health check probe that checks if the sensor is up and ready to receive traffic on the monitoring NIC"
  type        = string
  default     = "sensor-health-check"
}

variable "lb_management_probe_name" {
  description = "Name of the load balancer health probe that checks if SSH is available on the management NIC"
  type        = string
  default     = "ssh-health-check"
}

variable "lb_vxlan_rule_name" {
  description = "Name of the load balancer rule for VXLAN traffic"
  type        = string
  default     = "vxlan-lb-rule"
}

variable "lb_health_check_rule_name" {
  description = "Name of the load balancer rule for health check traffic"
  type        = string
  default     = "healthcheck-lb-rule"
}

variable "lb_ssh_rule_name" {
  description = "Name of the load balancer rule for SSH traffic"
  type        = string
  default     = "management-ssh-lb-rule"
}

variable "tags" {
  description = "Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}

variable "fleet_token" {
  type        = string
  default     = ""
  sensitive   = true
  description = "(optional) the pairing token from the Fleet UI. Must be set if 'fleet_url' is provided"
}

variable "fleet_url" {
  type        = string
  default     = ""
  description = "(optional) the URL of the fleet instance from the Fleet UI. Must be set if 'fleet_token' is provided"
}

variable "fleet_server_sslname" {
  type        = string
  default     = "1.broala.fleet.product.corelight.io"
  description = "(optional) the SSL hostname for the fleet server"
}

variable "fleet_http_proxy" {
  type        = string
  default     = ""
  description = "(optional) the proxy URL for HTTP traffic from the fleet"
}

variable "fleet_https_proxy" {
  type        = string
  default     = ""
  description = "(optional) the proxy URL for HTTPS traffic from the fleet"
}

variable "fleet_no_proxy" {
  type        = string
  default     = ""
  description = "(optional) hosts or domains to bypass the proxy for fleet traffic"
}
