#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
transmission-cli \
transmission-daemon

# Run transmission-daemon on boot
# sudo systemctl enable transmission-daemon
# sudo systemctl start transmission-daemon
# sudo usermod -a -G transmission $USER

# Notes on using transmission daemon: (https://cli-ck.io/transmission-cli-user-guide/)
# Remember to allow port 51413 on firewall
# Start daemon:              transmission-daemon
# Add new torrent:           transmission-remote -a "Add URL here"
# Download status:           transmission-remote -l
# Remove all torrents:       transmission-remote -t -all -r
# Remove specific torrent:   transmission-remote -t 3 -r
# Specify a download folder: transmission-daemon --download-dir "your-download-directory-path"

#############################################
# SHELL CONFIG
#############################################
echo 'alias tsm=transmission-remote' >> $HOME/.profile