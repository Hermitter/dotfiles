#!/usr/bin/env bash
TB_RUN="toolbox run $@"
toolbox create -y

# Increase DNF download speeds
$TB_RUN sudo bash -c "echo -e 'max_parallel_downloads=20\nfastestmirror=True' >> /etc/dnf/dnf.conf"

#############################################
# APPLICATIONS / DEPENDENCIES 
#############################################
$TB_RUN sudo dnf install -y \
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

$TB_RUN sudo dnf groupinstall -y "Development Tools"

# Set locale
$TB_RUN sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/zshrc'
$TB_RUN sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/bashrc'
$TB_RUN sudo bash -c 'echo -e "set -x LC_ALL C.UTF-8\n" >> /etc/fish/config.fish'

#############################################
# Expose host tools to toolbox 
#############################################
# podman
$TB_RUN sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman "\$@"
" > /usr/local/bin/podman'
$TB_RUN sudo chmod +x /usr/local/bin/podman

# podman-compose
$TB_RUN sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman-compose "\$@"
" > /usr/local/bin/podman-compose'
$TB_RUN sudo chmod +x /usr/local/bin/podman-compose

# xdg-open (Opens all URLs in the host)
$TB_RUN sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/xdg-open "\$@"
" > /usr/local/bin/xdg-open'
$TB_RUN sudo chmod +x /usr/local/bin/xdg-open

#############################################
# VS Code
#############################################
# Source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
$TB_RUN sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
$TB_RUN sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
$TB_RUN sudo dnf check-update
$TB_RUN sudo dnf install code -y

# Add missing VScode dependencies. This fixes: 
# - "error while loading shared libraries: libxshmfence.so.1"
# - missing emojis
$TB_RUN sudo dnf install -y \
qt5-qtwayland \
gdouros-symbola-fonts

# Create .desktop files to open toolbox GUI apps from host
function create_host_desktop_file {
    app_name=$1
    toolbox_destop_file=/usr/share/applications/$app_name.desktop
    host_desktop_file=~/.local/share/applications/$app_name.desktop

    $TB_RUN sed "s/Exec=/Exec=toolbox run /g" $toolbox_destop_file > $host_desktop_file
}

create_host_desktop_file "code"
