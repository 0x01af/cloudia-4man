
# GENERAL
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

# RPI_BASIC
variable "rpi_ip4_temporary" {
  description = "Raspberry Pi's IPv4 address, that has been temporarily assigned by DHCP."
  type        = string
}

variable "rpi_ip4" {
  description = "Raspberry Pi's IPv4 address, that has to be statically configured."
  type        = string
}
variable "rpi_ip6" {
  description = "Raspberry Pi's IPv6 address, that has to be statically configured."
  type        = string
}