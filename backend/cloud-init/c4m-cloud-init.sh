#!/bin/sh
# inspired by:
# - https://askubuntu.com/questions/1390827/how-to-make-ubuntu-autoinstall-iso-with-cloud-init-in-ubuntu-21-10/1391309#1391309

export ISO="https://releases.ubuntu.com/26.04/ubuntu-26.04-live-server-amd64.iso"
export ORIG_ISO="ubuntu-26.04-live-server-amd64.iso"
export MODDED_ISO="${ORIG_ISO::-4}-c4m.iso"
export TIMESTAMP=$(date +"%y%m%d%H%M%S00")

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
xorriso -as mkisofs --modification-date='${TIMESTAMP}' --grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:'${ORIG_ISO}' --protective-msdos-label -partition_cyl_align off -partition_offset 16 --mbr-force-bootable -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b --interval:local_fs:2470124d-2478587d::'ubuntu.iso' -part_like_isohybrid -iso_mbr_part_type a2a0d0ebe5b9334487c068b6b72699c7 -c '/boot.catalog' -b '/boot/grub/i386-pc/eltorito.img' -no-emul-boot -boot-load-size 4 -boot-info-table --grub2-boot-info -eltorito-alt-boot -e '--interval:appended_partition_2_start_617531s_size_8464d:all::' -no-emul-boot -boot-load-size 8464 -isohybrid-gpt-basdat -o /tmp/c4m-tmp/$MODDED_ISO -V 'c4m - ${ORIG_ISO}' /tmp/c4m-tmp/iso/
