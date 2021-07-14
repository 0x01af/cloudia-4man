
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

# RPI - configurable parameter
variable "rpi_ip4_temporary" {
  description = "Raspberry Pi's IPv4 address, that has been temporarily assigned by DHCP."
  type        = string
}

variable "rpi_hostname" {
  description = "Raspberry Pi's Hostname."
  type        = string
}

variable "rpi_ip4" {
  description = "Raspberry Pi's IPv4 address, that has to be statically configured."
  type        = string
}
variable "rpi_ip4_netprefix" {
  description = "Raspberry Pi's IPv4 net prefix (CIDR notation)"
  type        = string
}
variable "rpi_ip6" {
  description = "Raspberry Pi's IPv6 address, that has to be statically configured."
  type        = string
}

# RPI - well-defined parameter
variable "rpi_ip4_gateway" {
  description = "Raspberry Pi's Gateway for IPv4 address scope."
  type        = string
}
variable "rpi_ip4_dns" {
  description = "Raspberry Pi's DNS for IPv4 address scope."
  type        = string
}
variable "rpi_ip6_gateway" {
  description = "Raspberry Pi's Gateway for IPv6 address scope."
  type        = string
}
variable "rpi_ip6_dns" {
  description = "Raspberry Pi's DNS for IPv6 address scope."
  type        = string
}