#cloud-config
# Cloudia's cloud-init
# --------------------
# Author: github.com/0x01af
# Version: v2025-delta
# inspired by: https://www.jimangel.io/posts/automate-ubuntu-22-04-lts-bare-metal/
#
# This is the user-data configuration file for Ubuntu's autoinstall (a cloud-init-like configuration).
# More information: https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html
autoinstall:
  version: 1
  # (0x01af / feature idea): Replace the current autoinstall configuration with one provided by a trusted server
  # early-commands:
  #  - wget -O /autoinstall.yaml $TRUSTED_SERVER_URL

  network:
    version: 2
    renderer: networkd
    ethernets:
      enp1s0:
        match:
          name: enp1s0
        accept-ra: false
        dhcp6: false
        dhcp4: false
        addresses:
          - {{ ip4.address }}
          - '{{ ip6.address }}'
        gateway4: {{ ip4.gateway }}
        gateway6: '{{ ip6.gateway }}'
        nameservers:
          search: [{{ dns.domain }}]
          addresses: [{{ dns.ip4 }}, '{{ dns.ip6 }}']
  
  apt:
    fallback: offline-install
  
  storage:
    layout:
      # single-disk system: lvm layout is used by default;
      # multiple-disk system: no default is defined, but Longhorn recommend using LVM to aggregate all the disks;
      # => forcing the mostly recommended lvm layout
      name: lvm
      # Set the sizing-policy fix to scaled (default). If volume group is...
      # - less than 10 GiB: use all remaining space for the root file system
      # - between 10–20 GiB: 10 GiB root file system
      # - between 20–200 GiB: use half of the remaining space for the root file system
      # - greater than 200 GiB: 100 GiB root file system
      sizing-policy: scaled

  identity:
    hostname: {{ hostname }}

  ssh:
    install-server: true
    # option "allow-pw" defaults to "true" if option "authorized-keys" is empty, "false" otherwise. Set to "false", because "user-data" defines "ssh_authorized_keys".
    allow-pw: false

  drivers:
    install: true
  oem:
    install: true

  user-data:
    disable_root: true
    package_upgrade: false
    # Add users and groups to the system, and import keys with the ssh-import-id utility
    groups:
      - osoz-su
    users:
      - name: osoz-su
        gecos: Online Services of Z Superuser
        primary-group: osoz-su
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: [osoz-su, users, adm, audio, cdrom, dialout, dip, floppy, lxd, netdev, plugdev, sudo, video]
        lock_passwd: false
        passwd: {{ passwd_encrypted }}
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsUa+TiDLpHAEq8XWyUSeAku7A5WRhl1AT2wK3ltb12+exqsnvp2NKNmcD3Ind0t4/SHqAIp8ihHAF+oYyv3eFvpCIAL0TrXl/UhgEDcu3/MyLQYYwKeKQ/SjxezLraTBYzHLYne3zBBsX7FqyU1v4TU9OmH8RAS0jYYEM8GeCR4RztFnf9+wgIJjMW0jbBTw42AutKWjcYDOnTxqei2gEEQvnYn36CoawX1tZ/4J8AMvypcZOiJXuw3r8MU1a6o8WLFO9o3pt/pNSBQs9lTFaNFEgeRSOxqpBSikQSfleQ35y/Q3nWk8oZIavptf4vm+XCbswlKAsB/RDGbIq4l57bXwEHg8Y4rx72NO38WruDnkEsZc0CchtTHFiCpcSDd4iKIZFyu9o5zXTkkLwUHIoq64BLhf0X3fdrdLaX9QwqyqB1EMFiWqsAz3TSF0L516zpMWhsbhyXn2JhBl2HseFPI5+yAUOrQnlxCdJvMaH2hWKJeZB8B226TbqbQ+5PGc= oso@snarloso

  # "[late-commands] are run in the installer environment with the installed system mounted at /target."
  late-commands:
    # configure hostname
    - echo '{{ hostname }}' > /target/etc/hostname
    - echo '127.0.1.1 {{ hostname }}' > /target/etc/hosts
    # configure, that hostname and IP will be shown on login screen
    - echo 'Welcome on machine \n (\4; \6)' > /target/etc/issue
    # force shutdown
    - shutdown now
