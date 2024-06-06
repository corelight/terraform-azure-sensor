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

variable "virtual_network_name" {
  description = "The name of the virtual network the sensor will be deployed in"
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space of the virtual network the sensor be deployed in"
  type        = string
}

variable "virtual_network_resource_group" {
  description = "The resource group where the virtual network is deployed"
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
variable "sensor_subnet_name" {
  description = "The name of the subnet the VMSS will scale sensors in"
  type        = string
  default     = "cl-sensor-subnet"
}
variable "sensor_admin_username" {
  description = "The name of the admin user on the corelight sensor VM in the VMSS"
  type        = string
  default     = "corelight"
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
  default     = "vmss-sensor"
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

variable "lb_frontend_ip_config_name" {
  description = "Name of the internal load balancer frontend ip configuration"
  type        = string
  default     = "corelight-sensor-lb-ip"
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

variable "lb_health_check_probe_name" {
  description = "Name of the load balancer health check probe that check the sensor healthcheck API"
  type        = string
  default     = "health-check"
}

variable "lb_vxlan_rule_name" {
  description = "Name of the load balancer rule for VXLAN traffic"
  type        = string
  default     = "vxlan-lb-rule"
}

variable "lb_geneve_rule_name" {
  description = "Name of the load balancer rule for Geneve traffic"
  type        = string
  default     = "geneve-lb-rule"
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
