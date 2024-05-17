# terraform-azure-sensor

Terraform for Corelight's Azure Cloud Sensor Deployment.

<img src="docs/overview.svg" alt="overview">

## Getting Started
```hcl
resource "sensor" {
  source = "github.com/corelight/terraform-azure-sensor" 
  
  
}
```

### Deployment

The variables for this module all have default values that can be overwritten
to meet your naming and compliance standards.

Deployment examples can be found [here](examples).

## License

The project is licensed under the [MIT][] license.

[MIT]: LICENSE
