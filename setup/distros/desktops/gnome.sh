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

gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.desktop.interface gtk-theme    "adw-gtk3-dark"
gsettings set org.gnome.desktop.interface icon-theme   "Adwaita"
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"

# Flatpak isn't perfect at detecting our theme so we're exposing our local
# themes and then forcing a theme for GTK3 flatpak apps.
if exists flatpak; then
    flatpak override --user --filesystem=$HOME/.themes
    flatpak override --user --env=GTK_THEME=adw-gtk3-dark

    # Fix certain flatpak apps not using dark theme
    flatpak override --user org.gnome.TextEditor --unset-env=GTK_THEME
    flatpak override --user com.github.wwmm.easyeffects --unset-env=GTK_THEME
    flatpak override --user org.gnome.baobab --unset-env=GTK_THEME
    flatpak override --user org.gnome.Calendar --unset-env=GTK_THEME
    flatpak override --user org.gnome.Calculator --unset-env=GTK_THEME

    # Custom flatpak overrides
    flatpak override --user org.gnome.Shotwell --unshare=network 
fi

################################################################################
# Theme Settings
################################################################################

gsettings set org.gnome.desktop.interface cursor-size 32

gsettings set org.gnome.desktop.interface font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro Regular 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto Bold 11'


################################################################################
# Desktop Extensions
################################################################################

# enable extentions
gsettings set org.gnome.shell disable-user-extensions false

# TODO: Fix it not detected in first run for Silverblue (It's also set in the autostart script below)
# enable system tray
# gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# disable Fedora desktop watermark (idk why they insist on having this)
gnome-extensions disable background-logo@fedorahosted.org


################################################################################
# Desktop Behavior
################################################################################

# Enable fractional Scaling
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Disable ambient light sensor
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false

# Disable middle click paste
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false

# Use fingers for left/right/middle clicks
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'

# Click to focus on a window
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'

# Resize a window by holding right-click and dragging
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true 

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
gsettings set org.gnome.desktop.interface show-battery-percentage true


################################################################################
# Key Bindings
################################################################################

gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['<Primary><Alt><Super>Up']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['<Primary><Alt><Super>Down']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Primary><Alt><Super>Left','<Primary><Alt><Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super><Shift>Q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l','<Super><Shift>Return']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>D']"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super>S']"
gsettings set org.gnome.shell.keybindings show-screen-recording-ui "['<Super>R']"

# <Super>+number shortcuts to move apps and switch between workspaces
for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Shift><Super>$i']"
    
    # unset conflicting keybinds
    gsettings set org.gnome.shell.keybindings switch-to-application-$i '[]'
done

#################################################################################
# Custom Key Bindings
################################################################################
unset keybind_paths && declare keybind_paths
unset names && declare names
unset keybinds && declare keybinds
unset cmds && declare cmds
keybind () {
    names+=("'$1'")
    keybinds+=("'$2'")
    cmds+=("'$3'")
}

keybind 'Open Terminal' '<Super>Return' 'tilix'

# Create an array with an entry for each custom keybind
for ((i=0; i<${#keybinds[@]}; ++i)); do
    keybind_paths+=("'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$(($i+1))/'")
done
printf -v joined '%s, ' "${keybind_paths[@]}"
keybind_paths="\"[$(echo "${joined%, }")]\""

# Set the array of custom keybinds in gsettings
bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings $keybind_paths"

# For each custom keybind, set its name, binding, and command
for ((i=0; i<${#keybinds[@]}; ++i)); do
    id=$(($i+1))
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$id/ name ${names[$i]}"
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$id/ binding  ${keybinds[$i]}"
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$id/ command  ${cmds[$i]}"
done

#############################################
# Startup Script
#############################################
mkdir -p $HOME/.config/autostart

# Create autostart .desktop file
cat <<EOF > $HOME/.config/autostart/com.github.hermitter.dotfiles.desktop
[Desktop Entry]
Name=Launch GNOME Startup Apps
Type=Application
Exec=$HOME/.config/autostart/gnome-startup-script.sh 
Terminal=false
MimeType=x-scheme-handler/tg;
X-GNOME-UsesNotifications=true
EOF

# Create autostart script
STARTUP_SCRIPT_PATH="$HOME/.config/autostart/gnome-startup-script.sh"
cat <<EOF > $STARTUP_SCRIPT_PATH
#!/usr/bin/env bash
set -e

# enable extentions
gsettings set org.gnome.shell disable-user-extensions false

# enable system tray
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

function start_apps {
    for pair in "\$@"; do
        # split arg into seperate variables
        IFS=:; set -- \$pair
        NAME=\$1
        CMD=\$2

        if pgrep -x "\$NAME" > /dev/null
        then
            echo "Not starting '\$NAME'. App already running"
        else
            eval \$CMD &
        fi
    done

    # Kill each child process. The disown command was not used because an empty process was
    # left behind for each app that was disowned.
    pkill -P \$\$
}

# process_name : run_command
start_apps \
"nextcloud":"flatpak run com.nextcloud.desktopclient.nextcloud" \
"signal-desktop":"flatpak run org.signal.Signal --start-in-tray" \
"protonmail-bridge":"flatpak run ch.protonmail.protonmail-bridge --no-window" \
"geary":"flatpak run org.gnome.Geary --hidden"
EOF

chmod +x $STARTUP_SCRIPT_PATH