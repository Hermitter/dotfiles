#!/usr/bin/env bash
toolbox create -y

# Increase download speeds
toolbox run sudo bash -c "echo -e 'max_parallel_downloads=20\nfastestmirror=True' >> /etc/dnf/dnf.conf"

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
toolbox run sudo dnf install -y \
zsh \
fish \
starship \
exa \
bat \
trash-cli \
wl-clipboard \
nano \
openssl-devel \
net-tools \
nghttp2 \
usbutils \

toolbox run sudo dnf groupinstall -y "Development Tools"

#############################################
# Expose host tools to toolbox 
#############################################
TB_BIN=$HOME/.toolbox_bin

# podman
sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman "\$@"
" > /usr/local/bin/podman'
sudo chmod +x /usr/local/bin/podman

# podman-compose
sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman-compose "\$@"
" > /usr/local/bin/podman-compose'
sudo chmod +x /usr/local/bin/podman-compose

# xdg-open (Opens all URLs in the host)
sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/xdg-open "\$@"
" > /usr/local/bin/xdg-open'
sudo chmod +x /usr/local/bin/xdg-open

#############################################
# VS Code
#############################################
# Source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
toolbox run sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
toolbox run sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
toolbox run sudo dnf check-update
toolbox run sudo dnf install code -y

# Add missing VScode dependencies. This fixes: 
# - "error while loading shared libraries: libxshmfence.so.1"
# - missing emojis
toolbox run sudo dnf install -y \
qt5-qtwayland \
gdouros-symbola-fonts

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
