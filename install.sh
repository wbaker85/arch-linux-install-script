#!/bin/bash

echo "** INPUT DESIRED HOST NAME FOR COMPUTER **"
read HOSTNAME
echo "** INPUT DESIRED USER NAME FOR CONFIGURED USER **"
read USERNAME

# Update system clock
timedatectl set-ntp true

# Install reflector and prioritize mirrors
pacman -Syy
pacman -S reflector --noconfirm
reflector --sort rate -c 'United States' -f 10 --save /etc/pacman.d/mirrorlist

# Install the system
pacstrap /mnt base linux linux-firmware nano sudo man-db man-pages texinfo wpa_supplicant

# Swap file
arch-chroot /mnt dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress
arch-chroot /mnt chmod 600 /swapfile
arch-chroot /mnt mkswap /swapfile
arch-chroot /mnt swapon /swapfile

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Edit files before doing chroot stuff
ln -sf /mnt/usr/share/zoneinfo/America/Detroit /mnt/etc/localtime
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /mnt/etc/locale.gen
echo "LANG=en_US.UTF-8" >> /mnt/etc/locale.conf
echo $HOSTNAME >> /mnt/etc/hostname
echo -e "127.0.0.1 localhost\n::1 localhost\n192.168.1.200 $HOSTNAME.localdomain $HOSTNAME" >> /mnt/etc/hosts
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /mnt/etc/sudoers

# Copy network configs
cp network_files/25-wireless.network /mnt/etc/systemd/network/25-wireless.network
cp network_files/wpa_supplicant-wlp6s0.conf /mnt/etc/wpa_supplicant/wpa_supplicant-wlp6s0.conf
echo "nameserver 1.1.1.1" >> /mnt/etc/resolv.conf

# Set Time zone and configure locales
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt locale-gen

# Microcode updates
arch-chroot /mnt pacman -S amd-ucode --noconfirm

# User setup
arch-chroot /mnt useradd -m -G wheel $USERNAME

echo
echo "#####################"
echo "** ENTER DESIRED PASSWORD FOR ROOT AT THE NEXT PROMPT ** "
echo "#####################"
echo

arch-chroot /mnt passwd

echo
echo "#####################"
echo "** ENTER DESIRED PASSWORD FOR USER AT THE NEXT PROMPT ** "
echo "#####################"
echo

arch-chroot /mnt passwd $USERNAME

# Enable some services
arch-chroot /mnt systemctl enable systemd-networkd.service
arch-chroot /mnt systemctl enable wpa_supplicant@wlp6s0.service
arch-chroot /mnt systemctl enable fstrim.timer

echo
echo "#####################"
echo "INSTALL COMPLETE"
echo "#####################"
echo
