#!/usr/bin/env bash

# Remove conflicting dependencies
sudo dnf remove -y containers-common runc podman

# Install Docker (https://docs.docker.com/engine/install/centos/)
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io

# Enable/Start Docker service
sudo systemctl enable --now docker

# Add user to docker group (applies on reboot)
sudo usermod -aG docker $USER

# TODO: Find a repository instead of downloading a bin
# Install docker-compose (https://docs.docker.com/compose/install/)
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose