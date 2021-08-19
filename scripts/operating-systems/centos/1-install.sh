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
sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

sudo dnf upgrade -y 

# Install extra repositories
sudo dnf install -y epel-release elrepo-release

# Install essentials/dependencies
sudo dnf install -y \
zsh \
git \
bpytop \
trash-cli

# Enable Cockpit web dashboard (localhost:9090)
sudo systemctl enable --now cockpit.socket

# TODO: seperate docker into seperate file
# Install Docker
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io --allowerasing
sudo usermod -aG docker $USER
sudo systemctl enable --now docker

# Install docker-compose (https://docs.docker.com/compose/install/)
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install wireguard
sudo dnf install -y kmod-wireguard wireguard-tools
# sudo modprobe wireguard (enables wireguard until reboot)
