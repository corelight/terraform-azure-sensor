# terraform-azure-sensor

Terraform for Corelight's Azure Cloud Sensor Deployment.

<img src="docs/overview.svg" alt="overview">

## Usage

```terraform
module "sensor" {
  source = "github.com/corelight/terraform-azure-sensor"

  license_key                    = "<your Corelight sensor license key>"
  location                       = "<Azure location to deploy resources in>"
  resource_group_name            = "<resource group to deploy in>"
  corelight_sensor_image_id      = "<image resource id from Corelight>"
  community_string               = "<the community string (api string) often times referenced by Fleet>"
  sensor_ssh_public_key          = "<path to ssh public key>"
  management_subnet_id           = "<full management NIC subnet resource ID>"
  monitoring_subnet_id           = "<full management NIC subnet resource ID>"

  fleet_token = "<the pairing token from the Fleet UI>"
  fleet_url   = "<the URL of the fleet instance from the Fleet UI>"
  fleet_server_sslname = "<the ssl name provided by Fleet>"
  
  tags = {
    foo: bar,
    terraform: true,
    purpose: Corelight
  }
}
```

### Deployment

The variables for this module all have default values that can be overwritten
to meet your naming and compliance standards.

Deployment examples can be found [here][].

[here]: https://github.com/corelight/corelight-cloud/tree/main/terraform/azure-scaleset-sensor

#### Least Privilege Deployment
The Corelight Azure sensor can be deployed with the following privileges:

1. The `Network Contributor` built-in role
2. `Microsoft.Compute/images/read` on the Corelight VM Image
3. A custom role definition with the following permissions:
```
"Microsoft.Resources/subscriptions/resourcegroups/read"
"Microsoft.Compute/virtualMachineScaleSets/read"
"Microsoft.Insights/autoScaleSettings/read"
"Microsoft.Compute/virtualMachineScaleSets/write"
"Microsoft.Insights/autoScaleSettings/write"
```

## License

The project is licensed under the [MIT][] license.

[MIT]: LICENSE
