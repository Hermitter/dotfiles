#!/bin/bash
# Starts apps with the specified commands and avoids starting if already running.
# The app name used should the same as the process name.

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