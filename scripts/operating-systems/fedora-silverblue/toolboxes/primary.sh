#!/usr/bin/env bash
toolbox create -y

# Increase DNF download speeds
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

# Set locale
toolbox run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/zshrc'
toolbox run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/bashrc'
toolbox run sudo bash -c 'echo -e "set -x LC_ALL C.UTF-8\n" >> /etc/fish/config.fish'

#############################################
# Expose host tools to toolbox 
#############################################
TB_BIN=$HOME/.toolbox_bin

# podman
toolbox run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman "\$@"
" > /usr/local/bin/podman'
toolbox run sudo chmod +x /usr/local/bin/podman

# podman-compose
toolbox run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman-compose "\$@"
" > /usr/local/bin/podman-compose'
toolbox run sudo chmod +x /usr/local/bin/podman-compose

# xdg-open (Opens all URLs in the host)
toolbox run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/xdg-open "\$@"
" > /usr/local/bin/xdg-open'
toolbox run sudo chmod +x /usr/local/bin/xdg-open

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

# Create .desktop files to open toolbox GUI apps from host
function create_host_desktop_file {
    app_name=$1
    toolbox_destop_file=/usr/share/applications/$app_name.desktop
    host_desktop_file=~/.local/share/applications/$app_name.desktop

    toolbox run sed 's/Exec=/Exec=toolbox run /g' $toolbox_destop_file > $host_desktop_file
}

create_host_desktop_file "code"
