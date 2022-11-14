data "ncloud_server_image" "server_image" {
  count = var.server_image_name != null ? 1 : 0

  filter {
    name   = "product_name"
    values = [var.server_image_name]
  }
}

data "ncloud_member_server_image" "member_server_image" {
  count = var.member_server_image_name != null ? 1 : 0

  filter {
    name   = "name"
    values = [var.member_server_image_name]
  }
  region = var.member_server_image_region
}

locals {
  product_type = {
    "High CPU"      = "HICPU"
    "CPU Intensive" = "CPU"
    "High Memory"   = "HIMEM"
    "GPU"           = "GPU"
    "Standard"      = "STAND"
  }
}

data "ncloud_server_product" "server_product" {
  server_image_product_code = coalesce(one(data.ncloud_server_image.server_image.*.id),
    one(data.ncloud_member_server_image.member_server_image.*.original_server_image_product_code)
  )

  filter {
    name   = "generation_code"
    values = [upper(var.product_generation)]
  }
  filter {
    name   = "product_type"
    values = [local.product_type[var.product_type]]
  }
  filter {
    name   = "product_name"
    values = [var.product_name]
  }
}


resource "ncloud_launch_configuration" "launch_configuration" {
  name = var.name

  server_image_product_code = one(data.ncloud_server_image.server_image.*.id)
  member_server_image_no    = one(data.ncloud_member_server_image.member_server_image.*.id)
  server_product_code       = data.ncloud_server_product.server_product.id

  login_key_name      = var.login_key_name
  init_script_no      = var.init_script_id
  is_encrypted_volume = var.is_encrypted_volume
}
