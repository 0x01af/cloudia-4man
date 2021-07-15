network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      accept-ra: false
      dhcp6: false
      dhcp4: false
      addresses:
        - $${var.rpi_ip4}
        - "$${var.rpi_ip6}"
      gateway4: $${var.rpi_ip4_gateway}
      gateway6: "$${var.rpi_ip6_gateway}"
      nameservers:
        search: [$${var.rpi_dns_domain}]
        addresses: [$${var.rpi_ip4_dns}, "$${var.rpi_ip6_dns}"]