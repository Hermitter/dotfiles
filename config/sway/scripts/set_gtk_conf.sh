#!/bin/sh
# This script edits/adds to the gtk config file.
# Some apps require this to apply the proper theme
GTK_CONF_FILE=$HOME/.config/gtk-3.0/settings.ini

for pair in "$@"; do
    # split option_name and value ($1, $2)
    IFS=:; set -- $pair

    # Edit existing config
    if grep -q "$1=" $GTK_CONF_FILE; then
        # Avoid editing, if there's nothing to change
        if ! grep -q -x "$1=$2" $GTK_CONF_FILE; then
            # Match any line with $1 at the beginning and Replace with $1=$2
            sed -i "s/^$1.*/$1=$2/gm" $GTK_CONF_FILE
        fi
    # Add new config
    else
        echo $1=$2 >> $GTK_CONF_FILE
    fi
done

# Add Settings group, if missing
if ! grep "\[Settings\]" $GTK_CONF_FILE; then
    sed -i '1s/^/[Settings]\n/' $GTK_CONF_FILE
fi