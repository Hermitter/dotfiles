readonly LINUX_SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

################################################################################
# Distro
#
# Detect/Run the setup script for the current Linux distribution. 
################################################################################

# TODO: add more cases for distros not following https://www.man7.org/linux/man-pages/man5/os-release.5.html
if [ -f /etc/os-release ]; then
    . "/etc/os-release"
    OS=$ID
    VARIANT=$VARIANT_ID
else
    log_fatal 'Unable to detect Linux distro'
fi

if [[ $OS == 'fedora' ]] && [[ $VARIANT == 'silverblue' ]]; then
    log_status 'Setting up Silverblue'
    source "$LINUX_SCRIPT_DIR/silverblue.sh"
    log_success 'Set up Silverblue'
else
    log_status "Detected OS: $OS $VARIANT"
    log_fatal 'This distro has no setup scripts...'
fi

################################################################################
# Desktop
#
# Detect/Run the setup script for the current Desktop environment. 
################################################################################
if [[ "${DESKTOP_SESSION:-}" == 'gnome' ]]; then
    log_status 'Setting up GNOME desktop environment'
    source "$LINUX_SCRIPT_DIR/desktops/gnome.sh"
    log_success 'Set up GNOME desktop environment'
else
    log_fatal 'Unable to detect desktop environment'
fi

log_success 'System is now ready!'
log_todo 'Please reboot...'