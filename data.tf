data "cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/sensor_init.tpl",
      {
        api_password   = var.community_string
        sensor_license = var.license_key
        mgmt_int       = "eth0"
        mon_int        = "eth1"
      }
    )
    filename = "sensor-build.yaml"
  }
}

data "cloudinit_config" "config_with_enrichment" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/templates/sensor_init_with_enrichment.tpl",
      {
        api_password         = var.community_string
        sensor_license       = var.license_key
        mgmt_int             = "eth0"
        mon_int              = "eth1"
        container_name       = var.enrichment_storage_container_name
        storage_account_name = var.enrichment_storage_account_name
      }
    )
    filename = "sensor-build.yaml"
  }
}
