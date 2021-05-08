#!/usr/bin/env bash

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
sudo dnf install -y \
    sway \
    swaylock \
    swayidle \
    wlogout \
    waybar \
    mako \
    ranger \
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
    ImageMagick \
    blueman \
    NetworkManager-tui

# remove alacritty in favor of kitty
sudo dnf remove alacritty -y

#############################################
# CONFIGS
#############################################
# Wayshot is broken on the latest version of Ulauncher
# mkdir -p $HOME/.local/share/ulauncher/extensions
# git clone https://github.com/Hermitter/ulauncher-wayshot $HOME/.local/share/ulauncher/extensions/wayshot
