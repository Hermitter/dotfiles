#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
transmission-cli \
transmission-daemon

# Notes on using transmission daemon: (https://cli-ck.io/transmission-cli-user-guide/)
# Remember to allow port 51413 on firewall
# Start daemon:              transmission-daemon
# Add new torrent:           transmission-remote -a "Add URL here"
# Download status:           transmission-remote -l
# Remove all torrents:       transmission-remote -t -all -r
# Remove specific torrent:   transmission-remote -t 3 -r
# Specify a download folder: transmission-daemon --download-dir "your-download-directory-path"

# TODO: Start systemctl service under user
# Run transmission-daemon on boot
# sudo systemctl enable transmission-daemon
# sudo systemctl start transmission-daemon
# sudo usermod -a -G transmission $USER

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