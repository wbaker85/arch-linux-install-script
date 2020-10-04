# Arch Linux Install Script

This script is very specific to my hardware and preferences so it almost definitely won't work for your system as-is.  But it may be useful as a reference - feel free to customize as your wish for your own purposes!

- Uses systemd-boot as the boot manager.
- Uses systemd-networkd as the network manager.
- Packages the I use for daily tasks are listed in the `user_config.sh` script in no particular order.
- At the end of the `user_config.sh` script, there's a step for setting up a bare repo for dotfile version control.  Reference here for more information: https://www.atlassian.com/git/tutorials/dotfiles

### Usage

`install.sh` is the script for installing the base system and doing some low-level configuration.  Run this first, and then reboot / log in as the user created in the initial installation and run the `user_config.sh` script to set up the rest of the software.

**Prior to Running Anything**
* Configure wifi connection with `wifi-menu`
* Partition disks for UEFI booting - use `fdisk` and make it GPT filesystem
  * /dev/sda1 - 512 MB EFI (type `EFI System`)-> /mnt/boot (`mkfs.fat -F32 /dev/sda1`)
  * /dev/sda2 - 100 GB root -> /mnt (label as arch_os) (`mkfs.ext4 /dev/sda2`)
  * /dev/sda3 - rest -> /mnt/media (`mkfs.ext4 /dev/sda2`)

**After Running `install.sh` (but before you reboot)**
* bootloader config files are in `bootloader` folder - these go in `/boot/loader/` to use systemd-boot
* network config files are in `network_files` folder:
  * `25-wireless.network` goes in `/etc/systemd/network/` - script will copy it there
  * `wpa_supplicant-wlp6s0.conf` goes in `/etc/wpa_supplicant/` script will copy it there, but you need to update the password in that file
