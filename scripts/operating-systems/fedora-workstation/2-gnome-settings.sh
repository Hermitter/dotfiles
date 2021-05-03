#!/usr/bin/env bash

# Apply Theme
gsettings set org.gnome.desktop.interface gtk-theme "Materia-dark-compact"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
gsettings set org.gnome.desktop.interface cursor-size 32
gsettings set org.gnome.desktop.interface font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface document-font-name 'Roboto 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro Regular 10'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Roboto Bold 11'

# Extentions
gsettings set org.gnome.shell disable-user-extensions false
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

# Behavior
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'fingers'
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true 
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
gsettings set org.gnome.desktop.wm.preferences focus-mode 'click'

# Key Bindings
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>F']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>F4', '<Super><Shift>Q']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "['<Super>l','<Super><Shift>Return']"
gsettings set org.gnome.shell.keybindings toggle-overview "['<Super>D']"
# TODO: figure out why super+p doesn't work
# gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip "['<Super>P']"

# TODO: fix GNOME randomly overwritting (Super+number) shortcuts
for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Shift><Super>$i']"
done

# Custom Key Bindings
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
keybind 'Volume Up'          '<Ctrl><Super><Alt>Up'    'bash -c "amixer set Master unmute && amixer set Master 5%+"'
keybind 'Volume Down'        '<Ctrl><Super><Alt>Down'  'bash -c "amixer set Master unmute && amixer set Master 5%-"'
keybind 'Volume Mute LArrow' '<Ctrl><Super><Alt>Left'  'amixer set Master toggle'
keybind 'Volume Mute RArrow' '<Ctrl><Super><Alt>Right' 'amixer set Master toggle'
keybind 'Screenshot Tool'    '<Super><Shift>P'         'gnome-screenshot -i'

# - define an id for each keybind
for ((i=0; i<${#keybinds[@]}; ++i)); do
    keybind_paths+=("'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$(($i+1))/'")
done
printf -v joined '%s, ' "${keybind_paths[@]}"
keybind_paths="\"[$(echo "${joined%, }")]\""

# - apply each keybind to an id
bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings $keybind_paths"
for ((i=0; i<${#keybinds[@]}; ++i)); do
    offset=$(($i+1))
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$offset/ name ${names[$i]}"
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$offset/ binding  ${keybinds[$i]}"
    bash -c "gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom$offset/ command  ${cmds[$i]}"
done