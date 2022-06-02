#!/usr/bin/env bash
##################################################
########## Example to verify download ##########
# # Do this before you install the OS.
# # Get the latest keys here https://centos.org/keys/
# $ curl https://centos.org/keys/RPM-GPG-KEY-CentOS-Official | gpg
# $ gpg --verify-files CHECKSUM.asc 
# $ sha256sum -c *CHECKSUM

DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

# Increase DNF speeds
sudo bash -c "echo -e '[main]\nmax_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

sudo dnf upgrade -y 

# Install extra repositories
sudo dnf install -y epel-release elrepo-release

# Install essentials/dependencies
sudo dnf install -y \
util-linux-user \
zsh \
git \
bpytop \
trash-cli

# Add configs
mkdir -p ~/.config
# TODO: test
# cp $DOTFILES/config/starship.toml ~/.config

# Enable Cockpit web dashboard (localhost:9090)
sudo systemctl enable --now cockpit.socket

# Install wireguard
sudo dnf install -y kmod-wireguard wireguard-tools
# sudo modprobe wireguard (enables wireguard until reboot)
