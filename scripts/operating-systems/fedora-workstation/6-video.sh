#!/usr/bin/env bash

#############################################
# APPLICATIONS
#############################################
flatpak install -y \
flathub org.videolan.VLC \
com.makemkv.MakeMKV \
flathub fr.handbrake.ghb \
flathub org.bunkus.mkvtoolnix-gui

#############################################
# HELPFUL TIPS
#############################################
# HandBrake Compression Tutorial: https://www.imore.com/how-compress-video-handbrake
# 
# MakeMKV: Before using premium features or registering a key, set your system clock to before 2019
#          since the free beta key has already expired and you currently can't buy one.
#          Beta-Key: T-bzbIz9GKcA8KINjhv127mYiwwEuFmEiGa1aUNH7gdvOPCqvhQVXPnDdDlm62663Bo0 
# 
# VLC: BluRay disks can be played by registering a key in the MakeMKV app and by
#      installing some VLC plugins in the software center (I just install all of them).