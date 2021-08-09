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
variable "ip4_init" {
  description = "IPv4 address, that has been initially assigned by DHCP."
  type        = string
}

variable "hostname" {
  description = "Hostname of the machine"
  type        = string
}
