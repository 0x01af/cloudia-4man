# Pause
# -----
terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
      version = "3.1.0"
    }
  }
}

resource "null_resource" "pause" {
  
  provisioner "local-exec" {
    command = "printf '\n\nPAUSE - Please start your manual task or wait for something happends.\n\n'; read -n 1 -p 'Press any key to continue'"
  }
}