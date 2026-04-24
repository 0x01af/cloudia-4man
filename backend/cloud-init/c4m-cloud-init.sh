#!/bin/bash
# inspired by:
# - https://askubuntu.com/questions/1390827/how-to-make-ubuntu-autoinstall-iso-with-cloud-init-in-ubuntu-21-10/1391309#1391309

export UBUNTU_RELEASE="26.04"
export ORIG_ISO="ubuntu-${UBUNTU_RELEASE}-live-server-amd64.iso"
export DOWNLOAD_ISO="https://releases.ubuntu.com/${UBUNTU_RELEASE}/${ORIG_ISO}"
export MODDED_ISO="${ORIG_ISO::-4}-c4m.iso"

mkdir /tmp/c4m-tmp

# Download iso image
# sudo su -
wget -P /tmp/c4m-tmp $ISO

# Extract iso image
mkdir /tmp/c4m-tmp/iso
bsdtar -C /tmp/c4m-tmp/iso -xf /tmp/c4m-tmp/$ORIG_ISO

# Change grub.cfg
sed -i -E 's|/casper/vmlinuz\s+---|/casper/vmlinuz autoinstall quiet ---|' /tmp/c4m-tmp/iso/boot/grub/grub.cfg

# Create new iso image
export MKISOFS_ARGS=$(xorriso -indev /tmp/c4m-tmp/$ORIG_ISO -report_el_torito as_mkisofs 2>&1 | awk "/Volume id[[:space:]]*:[[:space:]]*'Ubuntu-Server/ {flag=1; next} flag {printf \"%s \", \$0}")
xorriso -as mkisofs $MKISOFS_ARGS -isohybrid-gpt-basdat -o /tmp/c4m-tmp/$MODDED_ISO /tmp/c4m-tmp/iso/
