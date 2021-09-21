#!/usr/bin/env bash
TOOLBOX=lutris-toolbox
toolbox create --container $TOOLBOX

# Increase download speeds
toolbox run --container $TOOLBOX sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
toolbox run --container $TOOLBOX sudo dnf install -y \
lutris \
wine

#############################################
# LINK HOST'S FIREFOX
#############################################
# Set host's firefox as the default browser
# This is so toolbox apps (mainly VScode) can open the host's browser
toolbox run --container $TOOLBOX sudo dnf install xdg-utils -y
HOST_FIREFOX="[Desktop Entry]
Version=1.0
Name=Firefox
Exec=flatpak-spawn --host firefox %u
Icon=firefox
Terminal=false
Type=Application
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
Actions=new-window;new-private-window;profile-manager-window;

X-Desktop-File-Install-Version=0.26

[Desktop Action new-window]
Name=Open a New Window
Exec=flatpak-spawn --host firefox --new-window %u

[Desktop Action new-private-window]
Name=Open a New Private Window
Exec=flatpak-spawn --host firefox --private-window %u

[Desktop Action profile-manager-window]
Name=Open the Profile Manager
Exec=flatpak-spawn --host firefox --ProfileManager
"
toolbox run --container $TOOLBOX bash -c "echo '$HOST_FIREFOX' | sudo tee /usr/share/applications/toolbox.host.firefox.desktop"
toolbox run --container $TOOLBOX xdg-settings set default-web-browser toolbox.host.firefox.desktop

#############################################
# LUTRIS DESKTOP FILE
#############################################
# Add .desktop file to toolbox's VScode
LUTRIS_DESKTOP="[Desktop Entry]
Name=Lutris
Comment=video game preservation platform
Categories=Game;
Keywords=gaming;wine;emulator;
Exec=toolbox run --container $TOOLBOX lutris %U
Icon=lutris
Terminal=false
Type=Application
MimeType=x-scheme-handler/lutris;
"
echo "$LUTRIS_DESKTOP" > ~/.local/share/applications/net.lutris.Lutris.desktop

# Set Lutris app to open lutris links
xdg-settings set default-url-scheme-handler lutris net.lutris.Lutris.desktop

#############################################
# GAME WORKAROUNDS
#############################################
# MTG ARENA: https://lutris.net/games/magic-the-gathering-arena/
# MSI DOWNLOAD: https://mtgarena-support.wizards.com/hc/en-us/articles/4402583467156-Installing-through-the-Windows-Installer-Package-MSI-
# DESCRIPTION: Requires you to manually download the .msi files and point to it
#              during the installation. Once installed point Lutris to use MTGA.exe instead
#              of MTGALAUNCHER.exe