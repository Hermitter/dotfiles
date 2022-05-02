#!/usr/bin/env bash
set -e

TB_RUN="toolbox run $@"
toolbox create -y

# Increase DNF download speeds
$TB_RUN sudo bash -c "echo -e 'max_parallel_downloads=20\nfastestmirror=True' >> /etc/dnf/dnf.conf"

####################################################
# APPLICATIONS / DEPENDENCIES 
####################################################
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
ImageMagick

$TB_RUN sudo dnf groupinstall -y "Development Tools"

# Set locale
$TB_RUN sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/zshrc'
$TB_RUN sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/bashrc'
$TB_RUN sudo bash -c 'echo -e "set -x LC_ALL C.UTF-8\n" >> /etc/fish/config.fish'

####################################################
# Expose host tools to toolbox 
####################################################
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

# TODO: cleanup as some of the paths used are not guranteed for all apps
function export_toolbox_app {
    app_name=$1
    icon_name=$2

    # Export .desktop #
    toolbox_destop_file=/usr/share/applications/$app_name.desktop
    host_desktop_file=~/.local/share/applications/$app_name.desktop
    $TB_RUN sed "s/Exec=/Exec=toolbox run /g" $toolbox_destop_file > $host_desktop_file

    # Export icons #
    icon_dir=~/.local/share/icons/hicolor
    large_icon=/usr/share/pixmaps/${icon_name}.png

    sizes=("16" "24" "32" "48" "64" "96" "128" "256" "512")

    for size in "${sizes[@]}"; do
      # Create folder for each size
      img_dir=${icon_dir}/${size}x${size}/apps
      mkdir -p $img_dir
      # Generate each icon size
      $TB_RUN convert -resize ${size}x${size} $large_icon ${img_dir}/${icon_name}.png
    done
}

####################################################
# VS Codium
# Source: https://vscodium.com/#install
#
# NOTICE: Installing X11 apps has issues
# when toolbox hostname != host's
# https://github.com/containers/toolbox/issues/586
# FIX: sudo hostname toolbox
####################################################

# Download
$TB_RUN sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
$TB_RUN bash -c 'printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo'
$TB_RUN sudo dnf install codium -y

# Create .desktop for host
export_toolbox_app "codium" "vscodium"

####################################################
# UNUSED AREA
####################################################
# VS Code
####################################################
## Source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
# $TB_RUN sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# $TB_RUN sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# $TB_RUN sudo dnf check-update
# $TB_RUN sudo dnf install code -y

## Add missing VScode dependencies. This fixes: 
## - "error while loading shared libraries: libxshmfence.so.1"
## - missing emojis
# $TB_RUN sudo dnf install -y \
# qt5-qtwayland \
# gdouros-symbola-fonts

# create_host_desktop_file "code"
