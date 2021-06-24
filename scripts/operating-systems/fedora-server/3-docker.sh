#!/usr/bin/env bash
sudo dnf install -y \
moby-engine \
docker-compose

sudo usermod -aG docker $USER

echo -e '\nFINISHED INSTALLING: 3-docker.sh\n~~~~~~~~~~ Please Reboot ~~~~~~~~~~\n'
