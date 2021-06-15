#!/usr/bin/env bash
ASSETS="$(dirname "$( realpath "${BASH_SOURCE[0]}")")/assets"

#############################################
# Desktop Theme
#############################################
gsettings set org.gnome.desktop.interface gtk-theme "Materia-dark-compact"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
gsettings set org.gnome.desktop.interface cursor-size 32
gsettings set org.gnome.desktop.interface font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro Regular 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto Bold 11'

#############################################
# Desktop Extentions
#############################################

# enable extentions
gsettings set org.gnome.shell disable-user-extensions false

# enable system tray
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# disable Fedora desktop icon
gnome-extensions disable background-logo@fedorahosted.org

#############################################
# Desktop Behavior
#############################################
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true 
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'
gsettings set org.gnome.desktop.interface show-battery-percentage true


# change max screencast length to 30 mins
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 1800

#############################################
# Key Bindings
#############################################
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['<Primary><Alt><Super>Up']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['<Primary><Alt><Super>Down']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['<Primary><Alt><Super>Left','<Primary><Alt><Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super><Shift>Q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l','<Super><Shift>Return']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>D']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screencast "['<Super><Shift>R']"

# Set Super+p area screenshot shortcut and remove conflicting keybind from area-screenshot-clip
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip "['<Super>P']"
gsettings set org.gnome.mutter.keybindings switch-monitor "['XF86Display']"

# Super+num shortcuts to move apps and switch between workspaces
for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Shift><Super>$i']"
    
    # unset conflicting switch-to-application keybinds
    gsettings set org.gnome.shell.keybindings switch-to-application-$i '[]'
done

#############################################
# Custom Key Bindings
#############################################
unset keybind_paths && declare keybind_paths
unset names && declare names
unset keybinds && declare keybinds
unset cmds && declare cmds
keybind () {
    names+=("'$1'")
    keybinds+=("'$2'")
    cmds+=("'$3'")
}

keybind 'Open Terminal'      '<Super>Return'           'tilix'
keybind 'Screenshot Tool'    '<Super><Shift>P'         'gnome-screenshot -i'

# create a path for each keybind
for ((i=0; i<${#keybinds[@]}; ++i)); do
    keybind_paths+=("'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$(($i+1))/'")
done
printf -v joined '%s, ' "${keybind_paths[@]}"
keybind_paths="\"[$(echo "${joined%, }")]\""

bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings $keybind_paths"

# apply a keybind for each path
for ((i=0; i<${#keybinds[@]}; ++i)); do
    offset=$(($i+1))
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$offset/ name ${names[$i]}"
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$offset/ binding  ${keybinds[$i]}"
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$offset/ command  ${cmds[$i]}"
done

#############################################
# Startup Script
#############################################
mkdir -p $HOME/.config/autostart
cp $ASSETS/gnome-startup-script.sh $HOME/.config/autostart/

# create autostart .desktop file if $STARTUP_SCRIPT exists
read -r -d '' DESKTOP_ENTRY << EOM 
[Desktop Entry]
Name=Launch GNOME Startup Apps
Type=Application
Exec=$HOME/.config/autostart/gnome-startup-script.sh 
Terminal=false
MimeType=x-scheme-handler/tg;
X-GNOME-UsesNotifications=true
EOM

echo "$DESKTOP_ENTRY" > $HOME/.config/autostart/com.github.hermitter.dotfiles.desktop
