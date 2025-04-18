#cloud-config

# This is the user-data configuration file for cloud-init. By default this sets
# up an initial user called "ubuntu" with password "ubuntu", which must be
# changed at first login. However, many additional actions can be initiated on
# first boot from this file. The cloud-init documentation has more details:
#
# https://cloudinit.readthedocs.io/
#
# Some additional examples are provided in comments below the default
# configuration.

# Enable password authentication with the SSH daemon
ssh_pwauth: true

## Add users and groups to the system, and import keys with the ssh-import-id
## utility
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
    passwd: $1$0v31uXwG$2VykMho3fYcJAwD2KkqYQ.
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsUa+TiDLpHAEq8XWyUSeAku7A5WRhl1AT2wK3ltb12+exqsnvp2NKNmcD3Ind0t4/SHqAIp8ihHAF+oYyv3eFvpCIAL0TrXl/UhgEDcu3/MyLQYYwKeKQ/SjxezLraTBYzHLYne3zBBsX7FqyU1v4TU9OmH8RAS0jYYEM8GeCR4RztFnf9+wgIJjMW0jbBTw42AutKWjcYDOnTxqei2gEEQvnYn36CoawX1tZ/4J8AMvypcZOiJXuw3r8MU1a6o8WLFO9o3pt/pNSBQs9lTFaNFEgeRSOxqpBSikQSfleQ35y/Q3nWk8oZIavptf4vm+XCbswlKAsB/RDGbIq4l57bXwEHg8Y4rx72NO38WruDnkEsZc0CchtTHFiCpcSDd4iKIZFyu9o5zXTkkLwUHIoq64BLhf0X3fdrdLaX9QwqyqB1EMFiWqsAz3TSF0L516zpMWhsbhyXn2JhBl2HseFPI5+yAUOrQnlxCdJvMaH2hWKJeZB8B226TbqbQ+5PGc= oso@snarloso
