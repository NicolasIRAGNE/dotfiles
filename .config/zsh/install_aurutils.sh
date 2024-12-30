#!/bin/bash

AUR_DB_PATH="$HOME/custompkgs"

# Step 1: Install aurutils
mkdir -p ~/aur
cd ~/aur
git clone https://aur.archlinux.org/aurutils.git
cd aurutils
makepkg -si

# Step 2: Create a local repository
sudo bash -c 'cat > /etc/pacman.d/custom' << EOF

[custom]
SigLevel = Optional TrustAll
Server = file://$AUR_DB_PATH
EOF

# Append Include = /etc/pacman.d/custom to the end of /etc/pacman.conf
sudo bash -c 'echo "Include = /etc/pacman.d/custom" >> /etc/pacman.conf'

# Create the repository root in AUR_DB_PATH and initialize the database
sudo install -d $AUR_DB_PATH -o $USER
repo-add $AUR_DB_PATH/custom.db.tar

# Step 3: Synchronize pacman
sudo pacman -Syu

# Step 4: Install aurutils with aurutils
aur sync -Su aurutils
sudo pacman -Syu


