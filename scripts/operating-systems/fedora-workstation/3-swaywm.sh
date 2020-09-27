#!/usr/bin/env bash

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
    sway swaylock swayidle wlogout waybar mako \
    nnn \
    ulauncher \
    brightnessctl \
    playerctl \
    kitty \
    cava \
    gnome-power-manager \
    wf-recorder \
    htop \
    swappy \
    slurp \
    grim \
    NetworkManager-tui

#############################################
# CONFIGS
#############################################
mkdir -p $HOME/.local/share/ulauncher/extensions
git clone https://github.com/Hermitter/ulauncher-wayshot $HOME/.local/share/ulauncher/extensions/wayshot