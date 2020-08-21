#!/bin/sh
# This script edits/adds to the gtk config file.
# Some apps require this to apply the proper theme
GTK_CONF_FILE=$HOME/.config/gtk-3.0/settings.ini

for pair in "$@"; do
    # split option_name and value ($1, $2)
    IFS=:; set -- $pair

    # Edit existing config
    if grep -q "$1=" $GTK_CONF_FILE; then
        # Avoid editing if config already exists
        echo setting found
        if ! grep -q -x "$1=$2" $GTK_CONF_FILE; then
            echo editing settings
            # 1. Match line with $1 if it's at the beggining
            # 2. Replace with new setting ($1=$2).
            sed -i "s/^$1.*/$1=$2/gm" $GTK_CONF_FILE
        fi
    # Add new config
    else
        echo $1=$2 >> $GTK_CONF_FILE
    fi
done