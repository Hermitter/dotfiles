import os
import subprocess
from ulauncher.api.shared.action.ExtensionCustomAction import ExtensionCustomAction
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
_file_destination = '$HOME/Pictures/'
_file_name = _file_destination + 'screenshot-$(date +"%Y-%m-%d-%H-%M-%S").png'
_notify_clipboard_save = ' && notify-send "Screenshot Taken" "Saved to clipboard"'
_notify_file_save = ' && notify-send "Screenshot Taken" "' + _file_name + '"'


def capture_monitor(save_to_clipboard):
    # Screenshot active Monitor
    command = 'grim -g "$(swaymsg -t get_outputs | jq -r \'.. | select(.active?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"\' | slurp)" '
    if save_to_clipboard:
        command += '- | wl-copy' + _notify_clipboard_save
    else:
        command += _file_name + _notify_file_save
    os.system(command)


def capture_window(save_to_clipboard):
    # Screenshot active window
    command = 'grim -g "$(swaymsg -t get_tree | jq -r \'.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"\' | slurp)" '
    if save_to_clipboard:
        command += '- | wl-copy' + _notify_clipboard_save
    else:
        command += _file_name + _notify_file_save
    os.system(command)


def capture_area(save_to_clipboard):
    # Screenshot drag&drop area
    command = 'grim -g "$(slurp)" '
    if save_to_clipboard:
        command += '- | wl-copy' + _notify_clipboard_save
    else:
        command += _file_name + _notify_file_save
    os.system(command)


capture = {
    'monitor': capture_monitor,
    'window': capture_window,
    'area': capture_area,
}


def get_save_menu(capture_method):
    # Menu to determine if screenshot is saved to file or clipboard
    menu = [
        ExtensionResultItem(
            name='Save To Clipboard',
            description='Copy a screenshot into the clipboard',
            icon='images/icon.svg',
            on_enter=ExtensionCustomAction(
                ({'action': 'clipboard_save', 'capture_method': capture_method}), False),
        ),

        ExtensionResultItem(
            name='Save To File',
            description='Save a screenshot to the ~/Pictures folder',
            icon='images/icon.svg',
            on_enter=ExtensionCustomAction(
                ({'action': 'file_save', 'capture_method': capture_method}), False),
        )

    ]

    return menu
