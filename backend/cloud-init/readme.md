
# Cloud-Init

## Ubuntu
General: https://www.jimangel.io/posts/automate-ubuntu-22-04-lts-bare-metal/

### Step 1: Create Ubuntu-Autoinstall-Boot-Image
https://askubuntu.com/questions/1390827/how-to-make-ubuntu-autoinstall-iso-with-cloud-init-in-ubuntu-21-10/1391309#1391309
- in WSL: run c4m-cloud-init.sh

### Step 2: Create USB Boot Drive
https://documentation.ubuntu.com/desktop/en/latest/how-to/create-a-bootable-usb-stick/
- in Windows: Rufus

### Step 3: Prepare user-data on second USB drive

## Raspberry Pi OS

### Step 1: Prepare SD drive with Raspberry Pi Imager

### Step 2: Prepare user-data on SD drive's bootfs partition
1. If partition bootfs isn't automatically mounted, open Windows Datenträgerverwaltung, and attach a drive letter.
2. Open file meta-data, add "local-hostname: <hostname>", and save it (please be aware about the UNIX format).
3. Copy file user-data based on user-data.tpl, edit file user-data, and save it (please be aware about the UNIX format).
