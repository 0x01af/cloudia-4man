terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

# Variables
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

# Module
resource "null_resource" "os_linux_configure_hostname" {
  connection {
    type = "ssh"
    user = "${var.su_username}"
    password = "${var.su_password}"
    host = "${var.ip4_init}"
  }  
  provisioner "remote-exec" {
    inline = [
      # UPDATE /ETC/HOSTS
      "echo '127.0.0.1 ${var.hostname}' | sudo tee -a /etc/hosts",
      # SET HOSTNAME
      "sudo hostnamectl set-hostname ${var.hostname}"
      ]
  }
}
