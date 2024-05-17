output "rendered_cloud_init" {
  value = data.cloudinit_config.config.rendered
}