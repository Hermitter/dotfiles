#!/usr/bin/env bash

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
    sway \
    nwg-launchers \
    swaylock \
    swayidle \
    wlogout \
    waybar \
    mako \
    ranger \
    ulauncher \
    rofi \
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
    ImageMagick \
    NetworkManager-tui

#############################################
# CONFIGS
#############################################
mkdir -p $HOME/.local/share/ulauncher/extensions
git clone https://github.com/Hermitter/ulauncher-wayshot $HOME/.local/share/ulauncher/extensions/wayshot
