#!/usr/bin/env bash
set -euxo pipefail

TOOLBOX_NAME=lutris-toolbox
toolbox create --container $TOOLBOX_NAME
tb_run() {
  toolbox run --container $TOOLBOX_NAME "$@"
}

# Increase download speeds
tb_run sudo bash -c "echo -e 'max_parallel_downloads=20\nfastestmirror=True' >> /etc/dnf/dnf.conf"

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
tb_run sudo dnf install -y \
lutris \
wine

# Set locale
tb_run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/bashrc'

#############################################
# Expose host tools to toolbox 
#############################################
tb_run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/xdg-open "\$@"
" > /usr/local/bin/xdg-open'
tb_run sudo chmod +x /usr/local/bin/xdg-open

#############################################
# LUTRIS DESKTOP FILE
#############################################
# Create .desktop files to open toolbox GUI apps from host
function create_host_desktop_file {
    app_name=$1
    toolbox_destop_file=/usr/share/applications/$app_name.desktop
    host_desktop_file=~/.local/share/applications/$app_name.desktop

    tb_run sed "s/Exec=/Exec=toolbox run --container "$TOOLBOX_NAME" /g" $toolbox_destop_file > $host_desktop_file
}

create_host_desktop_file "net.lutris.Lutris"

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