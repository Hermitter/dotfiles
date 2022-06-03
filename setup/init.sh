#!/usr/bin/env bash

################################################################################
# About
#
# The initial setup script for installing cloning 
# 'github.com/Hermitter/dotfiles' to `~/.dotfiles` if it doesn't exist.
################################################################################

# Prevent execution if this script was only partially downloaded.
{

set -euo pipefail

################################################################################
# Utility Functions
################################################################################

# ANSI styling (https://en.wikipedia.org/wiki/ANSI_escape_code#Description).
ANSI_CSI=$'\033['
STYLE_RED="${ANSI_CSI}0;31;1m"
STYLE_GREEN="${ANSI_CSI}0;32;1m"
STYLE_MAGENTA="${ANSI_CSI}0;35;1m"
STYLE_CYAN="${ANSI_CSI}0;36;1m"
STYLE_OFF="${ANSI_CSI}0m"

log_fatal() {
    echo "  ${STYLE_RED}fatal:${STYLE_OFF} $@" >&2
    exit 1
}

log_success() {
    echo "${STYLE_GREEN}success:${STYLE_OFF} $@" >&2
}

log_status() {
    echo " ${STYLE_MAGENTA}status:${STYLE_OFF} $@" >&2
}

log_skip() {
    echo "   ${STYLE_CYAN}skip:${STYLE_OFF} $@" >&2
}

################################################################################
# Git
#
# Ensure Git is installed.
################################################################################
 
if ! [[ -x "$(which git)" ]]; then
        log_fatal 'Git is not installed...'
fi

################################################################################
# Finish Bootstrap Phase
#
# Clone 'dotfiles' repo and continue setup.
################################################################################

DOTFILES_PATH="$HOME/.dotfiles"
POST_INIT_PATH="$DOTFILES_PATH/setup/post-init.sh"

if ! [[ -f "$POST_INIT_PATH" ]]; then
    log_status "Cloning 'Hermitter/dotfiles' repo into '$DOTFILES_PATH'…"

    # Clone with HTTPS for now because an SSH key pair has not yet been created.
    # After setting up SSH, the remote URL will be updated to use SSH.
    git clone https://github.com/Hermitter/dotfiles.git "$DOTFILES_PATH"
else
    log_skip "Cloning 'Hermitter/dotfiles' repo; found '$POST_INIT_PATH'"
fi

log_status "Running 'post-init.sh'…"
bash "$POST_INIT_PATH"

# End of partial download wrapping.
}