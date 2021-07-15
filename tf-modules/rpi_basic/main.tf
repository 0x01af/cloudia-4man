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
    user = "${var.su-username}"
    password = "${var.su-password}"
    host = "${var.rpi_ip4_temporary}"
  }
  
  provisioner "file" {
    content     = templatefile("${path.module}/netplan.tpl", {})
    destination = "/etc/netplan/99_config.yaml"
  }
  
  provisioner "remote-exec" {
    inline = [
      # SET HOSTNAME
      "sudo hostnamectl set-hostname ${var.rpi_hostname}",
      
      # SET FQDN IN /etc/host
      "echo '127.0.1.1 ${var.rpi_hostname}.${var.rpi_dns_domain}' | sudo tee -a /etc/hosts",
      
      # SET TIMEZONE
      "sudo timedatectl set-timezone Europe/Zurich",
      
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