terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

resource "null_resource" "rpi_k3s_server" {
  connection {
    type = "ssh"
    user = "${var.su_username}"
    password = "${var.su_password}"
    host = "${var.rpi_ip4}"
  }
  
  provisioner "file" {
    content     = templatefile("${path.module}/config.tpl", {
                    k3s_token = "${var.k3s_token}",
                    k3s_data_dir = "${var.k3s_data_dir}"
                  })
    destination = "/var/tmp/rpi_k3s_master_config.yaml"
  }
  
  provisioner "remote-exec" {
    inline = [
      
      # ENABLE CONTAINER FEATURES
      "echo ' cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1' | sudo tee -a /boot/firmware/cmdline.txt",
      
      # PREPARE K3S DATA DIR
      "sudo mkdir ${var.k3s_data_dir}",
      
      # MOVE K3S CONFIG
      "sudo mv /var/tmp/rpi_k3s_master_config.yaml /etc/rancher/k3s/config.yaml",
      
      # INSTALL K3S (but disable service to be able initializing HA cluster)
      "curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=TRUE INSTALL_K3S_EXEC='server' sh -",
      
      # REBOOT
      # Changed from 'sudo reboot' to 'sudo shutdown -r +0' to address exit status issue encountered
      # after Terraform 0.11.3, see https://github.com/hashicorp/terraform/issues/17844
      "sudo shutdown -r +0"
    ]
  }
  
  # kubeconfig: /etc/rancher/k3s/k3s.yaml
  
}