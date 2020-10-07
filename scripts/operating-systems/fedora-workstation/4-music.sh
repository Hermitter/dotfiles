#!/usr/bin/env bash

#############################################
# APPLICATIONS 
#############################################
sudo dnf install -y \
qsynth amsynth \
ardour5 

flatpak install -y net.sourceforge.VMPK

#############################################
# JACK SOUND SERVER 
#############################################
sudo dnf install -y \
jack-audio-connection-kit-dbus \
jack-audio-connection-kit-example-clients \
qjackctl

# Enable permissions for user (logout/login to apply changes)
sudo usermod -a -G jackuser $USER