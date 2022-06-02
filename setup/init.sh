#!/usr/bin/env bash

################################################################################
# About
#
# The initial setup script for installing git, if needed, and selecting the
# appropriate OS scripts to run 
#
# - Clones 'github.com/Hermitter/dotfiles' to `~/.dotfiles` if it doesn't exist.
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
# Download the repository
################################################################################




# Find 
realpath() {
    cd -- "$1" &>/dev/null && pwd -P
}
readonly SCRIPT_DIR="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"
cd "$SCRIPT_DIR/.."

echo $SCRIPT_DIR


# End of partial download wrapping.
}