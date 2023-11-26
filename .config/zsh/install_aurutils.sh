#!/bin/bash

# Step 1: Install aurutils
mkdir -p ~/aur
cd ~/aur
git clone https://aur.archlinux.org/aurutils.git
cd aurutils
makepkg -si

# Step 2: Create a local repository
sudo bash -c 'cat > /etc/pacman.d/custom' << EOF
[options]
CacheDir = /var/cache/pacman/pkg
CacheDir = /var/cache/pacman/custom
CleanMethod = KeepCurrent

[custom]
SigLevel = Optional TrustAll
Server = file:///var/cache/pacman/custom
EOF

# Append Include = /etc/pacman.d/custom to the end of /etc/pacman.conf
sudo bash -c 'echo "Include = /etc/pacman.d/custom" >> /etc/pacman.conf'

# Create the repository root in /var/cache/pacman
sudo install -d /var/cache/pacman/custom -o $USER

# Create the database in /var/cache/pacman/custom/
repo-add /var/cache/pacman/custom/custom.db.tar

# Step 3: Synchronize pacman
sudo pacman -Syu
