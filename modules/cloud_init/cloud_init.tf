data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/sensor_init.tpl", {
      api_password   = var.sensor_api_password
      sensor_license = var.license_key
      mgmt_int       = "eth0"
      mon_int        = "eth1"
    })
    filename = "sensor-build.yaml"
  }
}