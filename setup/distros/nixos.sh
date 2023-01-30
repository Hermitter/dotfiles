# Update packages
sudo nix-channel --update

# Get configs
mkdir -p "$HOME/.config"
cp -r $HOME/.dotfiles/config/* "$HOME/.config"

log_status 'Symlinking fish config'
rm -f -r ~/.config/fish
ln -sf "$HOME/.dotfiles/fish" "$HOME/.config/fish"

# Get personal scripts
mkdir -p "$HOME/.bin"
cp -r $HOME/.dotfiles/bin/* "$HOME/.bin"

# Get wallpapers
mkdir -p "$HOME/Pictures/Wallpapers"
cp -n -r $HOME/.dotfiles/images/Wallpapers/* "$HOME/Pictures/Wallpapers"

# Enable Flathub
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --enable flathub

FLATPAK_FLATHUB_PKGS=(
    # Apps
    com.spotify.Client
    org.signal.Signal
    com.discordapp.Discord
    com.nextcloud.desktopclient.nextcloud
    md.obsidian.Obsidian

    # Utilities
    com.github.tchx84.Flatseal # Flatpak Permissions Manager
    ch.protonmail.protonmail-bridge

    # Audio
    com.github.wwmm.easyeffects # EQ
    org.rncbc.qpwgraph # Pipewire Redirect
)

log_status 'Installing flatpak packages'
flatpak install flathub -y "${FLATPAK_FLATHUB_PKGS[@]}"
log_status 'Installed flatpak packages'