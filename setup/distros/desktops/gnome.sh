################################################################################
# GTK3 Theme: Adwaita
#
# https://github.com/lassekongo83/adw-gtk3/releases/latest/
################################################################################

mkdir -p "$HOME/.themes"

if ! [[ -d "$HOME/.themes/adw-gtk3" ]]; then
    log_status 'Installing Adwaita GTK theme'

    ADW_TMP=$(mktemp -d)
    ADW_TAR='adw-gtk3v2-0.tar.xz'
    wget -P "$ADW_TMP" "https://github.com/lassekongo83/adw-gtk3/releases/download/v2.0/$ADW_TAR"
    tar -C "$HOME/.themes" -xvf "$ADW_TMP/$ADW_TAR" adw-gtk3 adw-gtk3-dark

    log_success 'Installed Adwaita GTK theme'
else
    log_skip "Installing Adwaita GTK3 theme: '$HOME/.themes/adw-gtk3' exists"
fi

################################################################################
# Theme Settings
################################################################################

################################################################################
# Desktop Extensions
################################################################################

################################################################################
# Custom Key Bindings
################################################################################
