#!/usr/bin/env bash

#TODO: test this on a new machine

#############################################
# JACK SOUND SERVER 
#############################################
sudo dnf install -y pipewire-jack-audio-connection-kit

# Enable permissions for user (logout/login to apply changes)
# TODO: check if this is still needed
# sudo usermod -a -G jackuser $USER

#############################################
# APPLICATIONS 
#############################################
sudo dnf install -y \
qjackctl \
qsynth \
ardour5 