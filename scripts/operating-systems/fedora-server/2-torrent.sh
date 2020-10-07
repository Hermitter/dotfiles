#!/usr/bin/env bash
#############################################
# APPLICATION / SETUP 
#############################################
sudo dnf install -y transmission-daemon

# Add user to transmission group
sudo usermod -a -G transmission $USER

# Symbolic link to torrent downloads folder
# This is shared by anyone in the `transmission` group
sudo mkdir -p /var/lib/transmission/Downloads/
sudo ln -s /var/lib/transmission/Downloads/ $HOME/Torrents

# Add write access to download folder for anyone in the `transmission` group
sudo chmod 771 /var/lib/transmission/Downloads

# Run transmission-daemon on boot
sudo systemctl enable transmission-daemon
sudo systemctl start transmission-daemon

# Adjust the settings (TODO: just make a copy of the config file)
sudo systemctl stop transmission-daemon
TRANSMISSION_CONFIG=/var/lib/transmission/.config/transmission-daemon/settings.json
# Whitelist LAN IPs for Transmission Web GUI (http://localhost:9091)
sudo jq '.["rpc-whitelist"] = "127.0.0.1,192.168.*,::1"' $TRANSMISSION_CONFIG > tmp.$$.json && cat tmp.$$.json | sudo tee $TRANSMISSION_CONFIG
# Allow `transmission` group to write to newly created files
sudo jq '.["umask"] = 2' $TRANSMISSION_CONFIG > tmp.$$.json && cat tmp.$$.json | sudo tee $TRANSMISSION_CONFIG
rm tmp.$$.json
sudo systemctl start transmission-daemon

# Notes on using transmission daemon: (https://cli-ck.io/transmission-cli-user-guide/)
# Remember to allow port 51413 on firewall
# Add new torrent:           transmission-remote -a "Add URL here"
# Download status:           transmission-remote -l
# Remove all torrents:       transmission-remote -t -all -r
# Remove specific torrent:   transmission-remote -t 3 -r
# Specify a download folder: transmission-daemon --download-dir "your-download-directory-path"

#############################################
# FIREWALL SERVICES
# (Cheatsheet: https://gist.github.com/Hermitter/70fdda5af227519f335834d28b9b1847)
#############################################

# Web GUI
SERVICE_NAME=transmission-web-client
ZONE_NAME=FedoraServer
sudo firewall-cmd --permanent --new-service=$SERVICE_NAME
sudo firewall-cmd --permanent --service=$SERVICE_NAME --add-port=9091/udp
sudo firewall-cmd --permanent --service=$SERVICE_NAME --add-port=9091/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --permanent --zone=FedoraServer --add-service=$SERVICE_NAME
sudo firewall-cmd --reload

# Transmission Client
SERVICE_NAME=transmission-client
sudo firewall-cmd --permanent --zone=FedoraServer --add-service=$SERVICE_NAME
sudo firewall-cmd --reload

#############################################
# SHELL CONFIG
#############################################
echo 'alias tsm=transmission-remote' >> $HOME/.profile
