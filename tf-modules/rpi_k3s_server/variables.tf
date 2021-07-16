#
# MODULE - arguments
#
variable "su_username" {
  description = "Superuser's Username"
  type        = string
  sensitive   = true
}
variable "su_password" {
  description = "Superuser's Password"
  type        = string
  sensitive   = true
}
#
# RPI - configurable parameter
#
variable "rpi_ip4" {
  description = "Raspberry Pi's IPv4 address (CIDR notation), that has to be statically configured."
  type        = string
}
variable "k3s_token" {
  description = "K3s Token"
  type        = string
}
variable "k3s_data_dir" {
  description = "K3s Data Directory"
  type        = string
}