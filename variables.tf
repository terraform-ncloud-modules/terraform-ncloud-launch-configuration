variable "name" {
  type        = string
  description = "Name of the launch configuration"
}

variable "server_image_name" {
  type        = string
  description = "Name of the server image"
  default     = null
}

variable "member_server_image_name" {
  type        = string
  description = "Name of the member server image"
  default     = null
}

variable "member_server_image_region" {
  type        = string
  description = "Region of the member server image"
  default     = "KR"
}

variable "product_generation" {
  type        = string
  description = "Generation of the server product"
}

variable "product_type" {
  type        = string
  description = "Type of the server product"
}

variable "product_name" {
  type        = string
  description = "Name of the server product"
}

variable "login_key_name" {
  type        = string
  description = "Name of the login key"
}

variable "init_script_id" {
  type        = string
  description = "ID of the init script"
  default     = null
}

variable "is_encrypted_volume" {
  type        = bool
  description = "Whether to encrypt the volume"
  default     = false
}
