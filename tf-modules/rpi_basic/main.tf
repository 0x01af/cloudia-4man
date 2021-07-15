terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

resource "null_resource" "rpi_basic" {
  connection {
    type = "ssh"
    user = "${var.su_username}"
    password = "${var.su_password}"
    host = "${var.rpi_ip4_temporary}"
  }
  
  provisioner "file" {
    content     = templatefile("${path.module}/netplan.tpl", {
                    rpi_ip4 = var.rpi_ip4,
                    rpi_ip6 = var.rpi_ip6,
                    rpi_ip4_gateway = var.rpi_ip4_gateway,
                    rpi_ip6_gateway = var.rpi_ip6_gateway,
                    rpi_dns_domain = var.rpi_dns_domain,
                    rpi_ip4_dns = var.rpi_ip4_dns,
                    rpi_ip6_dns = var.rpi_ip6_dns
                  })
    destination = "/var/tmp/rpi_basic_99_config.yaml"
  }
  
  provisioner "file" {
    content     = templatefile("${path.module}/keyboard.tpl", {
                    kbmodel = "pc105",
                    kblayout = "ch"
                  })
    destination = "/var/tmp/rpi_basic_keyboard"
  }
  
  provisioner "remote-exec" {
    inline = [
      # SET HOSTNAME
      "sudo hostnamectl set-hostname ${var.rpi_hostname}",
      
      # SET FQDN IN /etc/host
      "echo '127.0.1.1 ${var.rpi_hostname}.${var.rpi_dns_domain}' | sudo tee -a /etc/hosts",
      
      # MOVE NETWORK CONFIG
      "sudo mv /var/tmp/rpi_basic_99_config.yaml /etc/netplan/99_config.yaml",
      
      # SET TIMEZONE
      "sudo timedatectl set-timezone Europe/Zurich",
      
      # MOVE KEYBOARD DEFINITION
      "sudo mv /var/tmp/rpi_basic_keyboard /etc/default/keyboard",
      
      # SET NTP SERVER
      # based on: https://superuser.com/questions/723441/how-to-replace-line-in-file-with-pattern-with-sed
      "sudo sed -i 's/NTP=.*/NTP=snarlrtr.mesh.local/' /etc/systemd/timesyncd.conf",
      "sudo sed -i 's/FallbackNTP=.*/FallbackNTP=192.168.123.1/' /etc/systemd/timesyncd.conf",
      
      # SYSTEM AND PACKAGE UPDATES
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt-get dist-upgrade -y",
      "sudo apt --fix-broken install -y",
      
      # OPTIMIZE GPU MEMORY
      "echo 'gpu_mem=16' | sudo tee -a /boot/config.txt",
      
      # REBOOT
      # Changed from 'sudo reboot' to 'sudo shutdown -r +0' to address exit status issue encountered
      # after Terraform 0.11.3, see https://github.com/hashicorp/terraform/issues/17844
      "sudo shutdown -r +0"
    ]
  }
  
}