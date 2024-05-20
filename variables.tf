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
}

variable "virtual_network_name" {
  description = "The name of the virtual network the sensor will observe traffic in"
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space of the virtual network the sensor will observe traffic in"
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

variable "sensor_api_password" {
  description = "The password that should be used for the Corelight sensor API"
  sensitive   = true
  type        = string
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
  type    = string
  default = "corelight-scale-set-autoscale-cfg"
}

variable "load_balancer_name" {
  type    = string
  default = "corelight-sensor-lb"
}

variable "scale_set_name" {
  type    = string
  default = "vmss-sensor"
}

variable "virtual_machine_size" {
  type    = string
  default = "Standard_D4s_v3"
}

variable "tags" {
  type    = object({})
  default = {}
}