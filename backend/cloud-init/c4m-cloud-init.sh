#!/sh/bash

export ISO="https://releases.ubuntu.com/26.04/ubuntu-26.04-live-server-amd64.iso"
export ORIG_ISO="ubuntu-26.04-live-server-amd64.iso"
export MODDED_ISO="${ORIG_ISO:-4}-c4m.iso"

mkdir /tmp/c4m-tmp

# Download iso image
# sudo su -
wget -P /tmp/c4m-tmp $ISO

# Mount iso image and copy original grub.cfg
mkdir /tmp/c4m-tmp/iso-mnt
sudo mount -o loop /tmp/c4m-tmp/$ORIG_ISO /tmp/c4m-tmp/iso-mnt
cp --no-preserve=all /tmp/c4m-tmp/iso-mnt/boot/grub/grub.cfg /tmp/c4m-tmp/grub.cfg
sudo umount /tmp/c4m-tmp/iso-mnt

# Change grub.cfg
sed -i 's/linux	\/casper\/vmlinuz  ---/linux	\/casper\/vmlinuz autoinstall quiet ---/g' /tmp/c4m-tmp/grub.cfg

# Modify and create new iso image
# chdir ~/livefs-edit
sudo livefs-edit /tmp/c4m-tmp/$ORIG_ISO /tmp/c4m-tmp/$MODDED_ISO --cp /tmp/c4m-tmp/grub.cfg new/iso/boot/grub/grub.cfg

