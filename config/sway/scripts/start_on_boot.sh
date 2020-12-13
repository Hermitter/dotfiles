#!/bin/bash
# Starts apps with the specified commands and avoids starting if already running.
# The app name used should the same as the process name.

for pair in "$@"; do
    # split app name and command ($1, $2)
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