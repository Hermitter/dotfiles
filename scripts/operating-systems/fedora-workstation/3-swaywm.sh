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
# todo clone hermitter/wayshot