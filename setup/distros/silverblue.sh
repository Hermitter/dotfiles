################################################################################
# Host System
################################################################################

# Increase DNF speeds
MAKE_DNF_FAST_CMD="echo -e '[main]\nmax_parallel_downloads=20\nfastestmirror=True' > /etc/dnf/dnf.conf"
sudo bash -c "$MAKE_DNF_FAST_CMD"

# System upgrade
rpm-ostree upgrade

# Enable Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

# Enable RPM Fusion free/non-free repos
rpm-ostree install --idempotent --apply-live https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Get configs
mkdir -p "$HOME/.config"
cp -r $HOME/.dotfiles/config/* "$HOME/.config"

# Get personal scripts
mkdir -p "$HOME/.bin"
cp -r $HOME/.dotfiles/bin/* "$HOME/.bin"

# Get wallpapers
mkdir -p "$HOME/Pictures/Wallpapers"
cp -n -r $HOME/.dotfiles/images/Wallpapers/* "$HOME/Pictures/Wallpapers"

SILVERBLUE_PKGS=(
    # Essentials
    fish
    zsh
    openssl
    podman-compose
    wl-clipboard
    exa
    bat
    ffmpeg

    # Desktop Environment
    tilix
    gnome-shell-extension-appindicator

    # Utilities
    bpytop

    # Fonts
    fira-code-fonts
    roboto-fontface-fonts
)

FLATPAK_FEDORA_PKGS=(
    # Apps
    com.transmissionbt.Transmission
    org.gnome.Extensions
    org.gnome.FileRoller # Archive Manager 
    org.gnome.Geary # Email
    org.gnome.Shotwell # Photo Gallery
)

FLATPAK_FLATHUB_PKGS=(
    # Apps
    org.gnome.Cheese # Camera
    org.gnome.Totem # Video Player
    org.gnome.Boxes
    com.valvesoftware.Steam
    com.spotify.Client
    org.signal.Signal
    com.discordapp.Discord
    com.slack.Slack
    com.nextcloud.desktopclient.nextcloud
    md.obsidian.Obsidian
    org.gnome.Boxes

    # Utilities
    com.github.tchx84.Flatseal # Flatpak Permissions Manager
    ch.protonmail.protonmail-bridge

    # Audio
    org.pulseaudio.pavucontrol # Volume
    com.github.wwmm.easyeffects # EQ
    org.rncbc.qpwgraph # Pipewire Redirect
)

log_status 'Installing silverblue packages'
rpm-ostree install --apply-live --idempotent "${SILVERBLUE_PKGS[@]}"
log_success 'Installed silverblue packages'

flatpak install fedora  -y "${FLATPAK_FEDORA_PKGS[@]}"
flatpak install flathub -y "${FLATPAK_FLATHUB_PKGS[@]}"

log_status "Setting shell to '/bin/fish'"
CHSH_CMD=(sudo usermod --shell '/bin/fish' "$USER")
"${CHSH_CMD[@]}"

log_status 'Symlinking fish config'
ln -sf "$HOME/.dotfiles/fish" "$HOME/.config/fish"

log_success "Set shell to '/bin/fish'"


################################################################################
# Development Toolbox
################################################################################

if ! podman container exists 'dev'; then
    toolbox create -y -c 'dev'
fi

tb_run() {
    toolbox run -c 'dev' "$@"
}

TOOLBOX_PKGS=(
    # Shell
    zsh
    fish
    starship
    exa
    bat
    trash-cli
    wl-clipboard
    nano

    # Dev tools
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

    # Utilities
    ImageMagick # `convert` app icons
)

tb_run sudo bash -c "$MAKE_DNF_FAST_CMD"
tb_run sudo dnf install -y "${TOOLBOX_PKGS[@]}"

tb_run "${CHSH_CMD[@]}"

# Set locale
tb_run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/zshrc'
tb_run sudo bash -c 'echo -e "export LC_ALL=C.UTF-8\n" >> /etc/bashrc'
tb_run sudo bash -c 'echo -e "set -x LC_ALL C.UTF-8\n" >> /etc/fish/config.fish'


################################################################################
# Development Toolbox: Import Host Tools
#
# Create scripts that calls specific tools from the host
################################################################################

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

# xdg-open
tb_run sudo bash -c 'echo "#\!/usr/bin/env bash
  flatpak-spawn --host /usr/bin/xdg-open "\$@"
" > /usr/local/bin/xdg-open'
tb_run sudo chmod +x /usr/local/bin/xdg-open


################################################################################
# Development Toolbox: VS Codium
#
# Source: https://code.visualstudio.com/docs/setup/linux#_rhel-fedora-and-centos-based-distributions
# Adapted from: https://github.com/Hermitter/dotfiles/blob/198f79a165e71bdf2a73ea22d255ca5786c482ba/scripts/operating-systems/fedora-silverblue/toolboxes/primary.sh#L81-L102
################################################################################

export_toolbox_app() {
    local app_name=$1
    local icon_name=$2

    log_status "Exporting toolbox app '$app_name'"

    # Export `.desktop` file.
    local toolbox_destop_file="/usr/share/applications/${app_name}.desktop"
    local host_desktop_file="${HOME}/.local/share/applications/${app_name}.desktop"

    tb_run sed 's/Exec=/Exec=toolbox run -c dev /g' "$toolbox_destop_file" > "$host_desktop_file"

    # Export icons.
    local icon_dir="${HOME}/.local/share/icons/hicolor"
    local icon_large="/usr/share/pixmaps/${icon_name}.png"
    local icon_sizes=(16 24 32 48 64 96 128 256 512)

    for size in "${icon_sizes[@]}"; do
        # Create folder for each size.
        local img_dir="${icon_dir}/${size}x${size}/apps"
        mkdir -p "$img_dir"

        # Generate each icon size.
        tb_run convert -resize "${size}x${size}" "$icon_large" "${img_dir}/${icon_name}.png"
    done

    log_success "Exported toolbox app '$app_name'"
}

TOOLBOX_CODE_PKGS=(
    code
    # Missing dep fixes:
    # - missing emojis
    qt5-qtwayland
    # - "error while loading shared libraries: libxshmfence.so.1"
    gdouros-symbola-fonts
)

tb_run sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
tb_run sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

tb_run sudo dnf check-update
tb_run sudo dnf install -y "${TOOLBOX_CODE_PKGS[@]}"

export_toolbox_app 'code' 'com.visualstudio.code'

# Fix X11 app issues when container & host have different hostnames
# Bugs: 
# - Blurry icons used
# - Desktop dock adds an icon for each app window
sudo hostname toolbox
