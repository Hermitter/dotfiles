#!/usr/bin/env bash
set -euxo pipefail

toolbox create -y

tb_run() {
  toolbox run "$@"
}

# Increase DNF download speeds
tb_run sudo bash -c "echo -e 'max_parallel_downloads=20\nfastestmirror=True' >> /etc/dnf/dnf.conf"

####################################################
# APPLICATIONS / DEPENDENCIES 
####################################################

BASE_PKGS=(
  # Shell
  zsh
  fish
  starship
  exa
  bat
  trash-cli
  wl-clipboard
  nano

  # Dev
  openssl-devel
  net-tools
  nghttp2
  usbutils

  # Packages from dnf "Development Tools" group
  gettext
  diffstat
  doxygen
  git
  gettext
  patch
  patchutils
  subversion
  systemtap  

  # Required for exporting icons in export_toolbox_app()
  ImageMagick
)

tb_run sudo dnf install -y "${BASE_PKGS[@]}"

# Set locale
tb_run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/zshrc'
tb_run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/bashrc'
tb_run sudo bash -c 'echo -e "set -x LC_ALL C.UTF-8\n" >> /etc/fish/config.fish'

####################################################
# Expose host tools to toolbox 
####################################################
# podman
tb_run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman "\$@"
" > /usr/local/bin/podman'
tb_run sudo chmod +x /usr/local/bin/podman

# podman-compose
tb_run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/podman-compose "\$@"
" > /usr/local/bin/podman-compose'
tb_run sudo chmod +x /usr/local/bin/podman-compose

# xdg-open (Opens all URLs in the host)
tb_run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/xdg-open "\$@"
" > /usr/local/bin/xdg-open'
tb_run sudo chmod +x /usr/local/bin/xdg-open

# TODO: cleanup as some of the paths used are not guranteed for all apps
# TODO: declare variables as local
function export_toolbox_app {
    local app_name=$1
    local icon_name=$2

    # Export .desktop #
    local toolbox_destop_file="/usr/share/applications/$app_name.desktop"
    local host_desktop_file="$HOME/.local/share/applications/$app_name.desktop"
    tb_run sed "s/Exec=/Exec=toolbox run /g" $toolbox_destop_file > $host_desktop_file

    # Export icons #
    local icon_dir=$HOME/.local/share/icons/hicolor
    local large_icon=/usr/share/pixmaps/${icon_name}.png

    for size in 16 24 32 48 64 96 128 256 512; do
      # Create folder for each size
      local img_dir="${icon_dir}/${size}x${size}/apps"
      mkdir -p $img_dir
      # Generate each icon size
      tb_run convert -resize ${size}x${size} $large_icon ${img_dir}/${icon_name}.png
    done
}

####################################################
# VS Codium
# Source: https://vscodium.com/#install
#
# NOTICE: Installing X11 apps has issues
# when toolbox's hostname != host's
# https://github.com/containers/toolbox/issues/586
# FIX: sudo hostname toolbox
####################################################
tb_run sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
tb_run bash -c 'printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscodium.repo'
CODIUM_PKGS=(
    codium
    # Fixes:
    # - missing emojis
    qt5-qtwayland
    # - error while loading shared libraries: libxshmfence.so.1
    gdouros-symbola-fonts
)
tb_run sudo dnf install -y "${CODIUM_PKGS[@]}"

export_toolbox_app "codium" "vscodium"