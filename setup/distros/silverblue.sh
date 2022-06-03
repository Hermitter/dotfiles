################################################################################
# Host System
################################################################################

# Increase DNF speeds
MAKE_DNF_FAST_CMD="echo -e '[main]\nmax_parallel_downloads=20\nfastestmirror=True' > /etc/dnf/dnf.conf"
sudo bash -c "$MAKE_DNF_FAST_CMD"

# Stop active background upgrades
if pgrep -x "$NAME" > /dev/null
then
    log_status 'Stopping Gnome Software'
    killall gnome-software
    log_success 'Stopping Gnome Software'
fi

rpm-ostree cancel

# System upgrade
rpm-ostree upgrade

# Enable Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

# Enable RPM Fusion free/non-free repos
rpm-ostree install --idempotent --apply-live https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Get configs
mkdir -p $HOME/.config
cp -n -r ./config/* $HOME/.config

# Get personal scripts
mkdir -p $HOME/.bin
cp -n -r ./bin/* $HOME/.bin

# Get wallpapers
mkdir -p $HOME/Pictures/Wallpapers
cp -n -r ./images/Wallpapers/* $HOME/Pictures/Wallpapers

SILVERBLUE_PKGS=(
    # Essentials
    fish
    zsh
    openssl
    podman-compose
    wl-clipboard
    exa
    bat
    starship
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
    org.gnome.FileRoller
    org.gnome.Geary
)

FLATPAK_FLATHUB_PKGS=(
    # Apps
    org.gnome.Cheese # Camera
    org.gnome.Totem # Video Player
    org.gnome.Boxes
    com.valvesoftware.Steam
    com.spotify.Client
    org.telegram.desktop
    org.signal.Signal
    com.discordapp.Discord
    com.slack.Slack
    com.nextcloud.desktopclient.nextcloud
    md.obsidian.Obsidian
    org.gnome.Boxes

    # Utilities
    com.github.tchx84.Flatseal # Flatpak Permissions Manager
    ch.protonmail.protonmail-bridge
    org.wireshark.Wireshark

    # Audio
    org.pulseaudio.pavucontrol # Volume
    com.github.wwmm.easyeffects # EQ
    org.rncbc.qpwgraph # Pipewire Redirect
)

rpm-ostree install --apply-live --idempotent "${SILVERBLUE_PKGS[@]}"
flatpak install fedora  -y "${FLATPAK_FEDORA_PKGS[@]}"
flatpak install flathub -y "${FLATPAK_FLATHUB_PKGS[@]}"

