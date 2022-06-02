#!/usr/bin/env bash

################################################################################
# About
#
# The setup script run after `init.sh` has `git clone` the dotfiles repo.
################################################################################

set -euo pipefail

realpath() {
    cd -- "$1" &>/dev/null && pwd -P
}

readonly SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

cd "$SCRIPT_DIR/.."

source "$SCRIPT_DIR/util.sh"

################################################################################
# Config Variables
################################################################################

USER_NAME='Carlos Chacin'
USER_EMAIL='Hermitter@jellyapple.com'

################################################################################
# SSH Config
################################################################################
SSH_ALGO='ed25519' # https://www.ssh.com/academy/ssh/keygen#choosing-an-algorithm-and-key-size
SSH_KEY_PATH="$HOME/.ssh/id_$SSH_ALGO"
SSH_CONFIG_PATH="$HOME/.ssh/config"

if ! [[ -f "$SSH_KEY_PATH" ]]; then
    echo "$SSH_KEY_PATH"

    log_status $'Generating SSH key…\a'
    ssh-keygen -f "$SSH_KEY_PATH" -t "$SSH_ALGO" -C "$USER_EMAIL"

    eval "$(ssh-agent -s)"
    
    ssh-add "$SSH_KEY_PATH"

    log_success 'Generated SSH key and added it to `ssh-agent`'
else
    log_skip "SSH setup; found '$SSH_KEY_PATH'"
fi

################################################################################
# Git Config
################################################################################

log_status 'Configuring `git`…'

git config --global user.name  "$USER_NAME"
git config --global user.email "$USER_EMAIL"

git config --global core.editor 'code --wait'
git config --global init.defaultbranch main

# Use SSH for dotfiles repo.
git remote set-url origin 'git@github.com:Hermitter/dotfiles.git'

log_success 'Configured `git`'

log_todo "Add public key '$SSH_KEY_PATH.pub' to GitHub: https://github.com/settings/ssh/new"

################################################################################
# Distro-Specific Init
################################################################################

source "$SCRIPT_DIR/distros/init.sh"