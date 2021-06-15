#!/usr/bin/env bash
toolbox create -y

# Increase download speeds
toolbox run sudo bash -c "echo -e 'max_parallel_downloads=10\nfastestmirror=True' >> /etc/dnf/dnf.conf"

# Install essential apps and deps
toolbox run sudo dnf install -y \
zsh \
fish \
starship \
exa \
bat \
bpytop \
trash-cli \
wl-clipboard \
nano \
openssl-devel \
nghttp2

sudo dnf groupinstall -y "Development Tools"

# Toolbox aliases to host programs
echo "if [[ ! -v $TOOLBOX_PATH ]] | [[ ! -z $TOOLBOX_PATH ]]; then
    alias podman='flatpak-spawn --host podman'
fi" >> ~/.profile

# Install vscode in toolbox
# Source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
toolbox run sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
toolbox run sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
toolbox run sudo dnf check-update
toolbox run sudo dnf install code -y

# VScode dependency to solve inconsistent error: "error while loading shared libraries: libxshmfence.so.1"
toolbox run sudo dnf install qt5-qtwayland -y

# Set host's firefox as the default browser
# This is so toolbox apps (mainly VScode) can open the host's browser
toolbox run sudo dnf install xdg-utils -y
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
toolbox run bash -c "echo '$HOST_FIREFOX' | sudo tee /usr/share/applications/toolbox.host.firefox.desktop"
toolbox run xdg-settings set default-web-browser toolbox.host.firefox.desktop

# TODO: figure out why this doesn't work. Ideally, this would've been a simpler solution for URLS than the above code.
# Add a PATH variable xdg-open that points to host machine's xdg-open 
# CUSTOM_XDG_OPEN=~/.bin/xdg-open    
# echo '#!/bin/sh
# if [[ -v $TOOLBOX_PATH ]] | [[ -z $TOOLBOX_PATH ]]; then
#   echo "THIS IS HOST"
#   /usr/bin/xdg-open "$@"
# else
#   echo "THIS IS TOOLBOX"
#   ${TOOLBOX_PATH:+flatpak-spawn --host} /usr/bin/xdg-open "$@"
# fi
# ' > $CUSTOM_XDG_OPEN
# chmod +x $CUSTOM_XDG_OPEN

# Add alias to toolbox's VScode
echo 'alias code="toolbox run code"' >> ~/.profile

# Add .desktop file to toolbox's VScode
VSCODE_DESKTOP="[Desktop Entry]
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=toolbox run code --unity-launch %F
Icon=com.visualstudio.code
Type=Application
StartupNotify=false
StartupWMClass=Code
Categories=Utility;TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;application/x-code-workspace;
Actions=new-empty-window;
Keywords=vscode;

[Desktop Action new-empty-window]
Name=New Empty Window
Exec=toolbox run code --new-window %F
Icon=com.visualstudio.code
"
echo "$VSCODE_DESKTOP" > ~/.local/share/applications/code.desktop
