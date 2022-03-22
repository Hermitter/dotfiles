#!/usr/bin/env bash
set -e

# enable extentions
gsettings set org.gnome.shell disable-user-extensions false

# enable system tray
gnome-extensions enable appindicatorsupport@rgcjonas.gmail.com

function start_apps {
    for pair in "$@"; do
        # split arg into seperate variables
        IFS=:; set -- $pair
        NAME=$1
        CMD=$2

        if pgrep -x "$NAME" > /dev/null
        then
            echo "Not starting '$NAME'. App already running"
        else
            eval $CMD &
        fi
    done

    # Kill each child process. The disown command was not used because an empty process was
    # left behind for each app that was disowned.
    pkill -P $$
}

# process_name : run_command
start_apps \
"telegram-deskto":"flatpak run org.telegram.desktop -startintray" \
"dropbox":"flatpak run com.dropbox.Client" \
"signal-desktop":"flatpak run org.signal.Signal --start-in-tray" \
"geary":"geary --hidden"