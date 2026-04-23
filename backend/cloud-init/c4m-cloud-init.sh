#!/sh/bash

export ISO="https://releases.ubuntu.com/22.04/ubuntu-22.04.1-live-server-amd64.iso"
export ORIG_ISO="ubuntu-22.04.1-live-server-amd64.iso"
export MODDED_ISO="${ORIG_ISO::-4}-c4m.iso"

mkdir /tmp/c4m-tmp
chdir /tmp/c4m-tmp

# Download iso image
sudo su -
wget $ISO

# Mount iso image
mkdir /tmp/c4m-tmp/iso-mnt
mount -o loop $ORIG_ISO iso-mnt

# Copy original grub.cfg
cp --no-preserve=all iso-mnt/boot/grub/grub.cfg /tmp/c4m-tmp/grub.cfg

# Change grub.cfg
sed -i 's/linux	\/casper\/vmlinuz  ---/linux	\/casper\/vmlinuz autoinstall quiet ---/g' /tmp/c4m-tmp/grub.cfg

# Modify and create new iso image
chdir ~/livefs-edit
livefs-edit /tmp/c4m-tmp/$ORIG_ISO /tmp/c4m-tmp/$MODDED_ISO --cp /tmp/c4m-tmp/grub.cfg new/iso/boot/grub/grub.cfg
