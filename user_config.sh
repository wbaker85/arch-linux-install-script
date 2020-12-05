#!/bin/bash

# More timezone stuff, and mirror list
sudo timedatectl set-timezone America/Detroit
sudo timedatectl set-ntp true
sudo pacman -Syy
sudo pacman -S reflector --noconfirm
sudo reflector --sort rate -c 'United States' -f 50 --save /etc/pacman.d/mirrorlist

# Use more processors for makepkg
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j4"/' /etc/makepkg.conf

# Programs
sudo pacman -S --needed base-devel --noconfirm
sudo pacman -S \
  xf86-video-amdgpu xorg-server xorg-xinit xorg-xfontsel xorg-xrandr \
  alacritty git numlockx screen nethogs zip unzip wget curl tree \
  i3 i3status dmenu feh picom \
  code firefox rclone docker docker-compose python-llfuse \
  pulseaudio pavucontrol vlc deepin-screenshot gpicview \
  --noconfirm

# Fonts
mkdir -p $HOME/.config/fontconfig
sudo pacman -S ttf-dejavu --noconfirm

# Make an SSH key
mkdir $HOME/.ssh
cat /dev/zero | ssh-keygen -q -N ""

# Config files
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
git clone --bare git@github.com:wbaker85/dotfiles.git $HOME/.cfg
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no
