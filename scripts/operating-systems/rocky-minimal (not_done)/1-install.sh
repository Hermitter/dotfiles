#!/usr/bin/env bash
DOTFILES="$(dirname $(dirname $(dirname $(dirname "$( realpath "${BASH_SOURCE[0]}")"))))"

# Increase DNF speeds
sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

sudo dnf upgrade -y 

# Add wireguard (not working)
# sudo dnf install -y epel-release elrepo-release
# sudo dnf install -y kmod-wireguard wireguard-tools