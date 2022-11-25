# Multiple Launch Configuration Module

## **This version of the module requires Terraform version 1.3.0 or later.**

This document describes the Terraform module that creates multiple Ncloud Launch Configurations.

## Variable Declaration

### Structure : `variable.tf`

You need to create `variable.tf` and copy & paste the variable declaration below.

**You can change the variable name to whatever you want.**

``` hcl
variable "launch_configurations" {
  type = list(object({
    name = string

    server_image_name          = optional(string, null)      // "Image Name" on "terraform-ncloud-docs"
    member_server_image_name   = optional(string, null)      // Member Server Image name you created.
    member_server_image_region = optional(string, "KR")      // Member Server Image region you created.
    product_generation         = string                      // "Gen" on "Server product" page on "terraform-ncloud-docs"
    product_type               = string                      // "Type" on "Server product" page on "terraform-ncloud-docs"
    product_name               = string                      // "Product Name" on "Server product" page on "terraform-ncloud-docs"

    login_key_name      = string
    init_script_id      = optional(string, null)
    is_encrypted_volume = optional(bool, false)

  }))
  default = []
}

```

### Example : `terraform.tfvars`

You can create a `terraform.tfvars` and refer to the sample below to write the variable specification you want.
File name can be `terraform.tfvars` or anything ending in `.auto.tfvars`

**It must exactly match the variable name above.**

``` hcl
launch_configurations = [
  {
    name = "lc-foo"

    // you can use "server_image_name" the same as in the Server Module.
    server_image_name  = "CentOS 7.8 (64-bit)"
    // or if you created "member_server_image", you can use it instead.
    # member_server_image_name = "img-foo"
    # member_server_image_region = "KR"
    
    product_generation = "G2"
    product_type       = "High CPU"
    product_name       = "vCPU 2EA, Memory 4GB, [SSD]Disk 50GB"

    login_key_name      = "key-workshop"
    # init_script_id      = 12345
    is_encrypted_volume = false
  }
]

```

## Module Declaration

### `main.tf`

Map your `Launch Configuration variable name` to a `local Launch Configuration variable`. `Launch Configuration module` are created using `local Launch Configuration variables`. This eliminates the need to change the variable name reference structure in the `Launch Configuration module`.

``` hcl
locals {
  launch_configurations = var.launch_configurations
}
```

Then just copy & paste the module declaration below.

``` hcl

module "launch_configurations" {
  source = "terraform-ncloud-modules/launch-configuration/ncloud"

  for_each = { for lc in local.launch_configurations : lc.name => lc }

  name                       = each.value.name
  server_image_name          = each.value.server_image_name
  member_server_image_name   = each.value.member_server_image_name
  member_server_image_region = each.value.member_server_image_region
  product_generation         = each.value.product_generation
  product_type               = each.value.product_type
  product_name               = each.value.product_name
  login_key_name             = each.value.login_key_name
  init_script_id             = each.value.init_script_id
  is_encrypted_volume        = each.value.is_encrypted_volume

}

```

## image & product reference scenario

You can find out values for server image & product on [terraform-ncloud-docs](https://github.com/NaverCloudPlatform/terraform-ncloud-docs/blob/main/docs/server_image_product.md). You must `Copy & Paste` values exactly.

``` hcl
//variable
server_image_name  = "CentOS 7.8(64-bit)"                     // "Image Name" on "terraform-ncloud-docs"
product_generation = "G2"                                     // "Gen" on "Server product" page on "terraform-ncloud-docs"
product_type       = "High CPU"                               // "Type" on "Server product" page on "terraform-ncloud-docs"
product_name       = "vCPU 2EA, Memory 4GB, [SSD]Disk 50GB"   // "Product Name" on "Server product" page on "terraform-ncloud-docs"
```