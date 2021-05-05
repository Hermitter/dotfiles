#!/usr/bin/env bash

#############################################
# APPLICATIONS 
#############################################

flatpak install -y flathub \
org.gnome.Extensions \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
com.discordapp.Discord \
com.slack.Slack \
org.gabmus.hydrapaper \
com.dropbox.Client \
md.obsidian.Obsidian \
com.github.alainm23.planner

#############################################
# CONFIGS 
#############################################

# Tell Signal to use system tray
sudo sed -i -e '/Exec=/s/$/ --use-tray-icon/' /var/lib/flatpak/app/org.signal.Signal/current/active/export/share/applications/org.signal.Signal.desktop
