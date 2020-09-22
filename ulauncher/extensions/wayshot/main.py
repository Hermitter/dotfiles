import json
import os
import screenshot
import subprocess
from ulauncher.api.client.Extension import Extension
from ulauncher.api.client.EventListener import EventListener
from ulauncher.api.shared.event import KeywordQueryEvent, ItemEnterEvent
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
from ulauncher.api.shared.action.RenderResultListAction import RenderResultListAction
from ulauncher.api.shared.action.HideWindowAction import HideWindowAction
from ulauncher.api.shared.action.ExtensionCustomAction import ExtensionCustomAction


class Wayshot(Extension):

    def __init__(self):
        super(Wayshot, self).__init__()
        self.subscribe(KeywordQueryEvent, KeywordQueryEventListener())
        self.subscribe(ItemEnterEvent, ItemEnterEventListener())


class ItemEnterEventListener(EventListener):
    # Handle selected item
    def on_event(self, event, extension):
        data = event.get_data()
        action = data['action']

        # capture method
        if action == "screenshot_monitor":
            return RenderResultListAction(screenshot.get_save_menu('monitor'))
        elif action == "screenshot_window":
            return RenderResultListAction(screenshot.get_save_menu('window'))
        elif action == "screenshot_area":
            return RenderResultListAction(screenshot.get_save_menu('area'))

        # color picker
        elif action == 'color_picker':
            # Copy pixel's hex color to clipboard
            get_color = "grim -g \"$(slurp -p)\" -t ppm - | convert - -format '#%[hex:u]' info:"
            color = subprocess.check_output(
                get_color, shell=True).decode("utf-8")
            os.system(
                "notify-send 'Copied {}' && wl-copy \{}".format(color, color))

        # save method
        elif action == 'file_save':
            screenshot.capture[data['capture_method']](False)
        elif action == 'clipboard_save':
            screenshot.capture[data['capture_method']](True)


class KeywordQueryEventListener(EventListener):
    # Create menu and emit the selected item
    def on_event(self, event, extension):
        menu = [
            ExtensionResultItem(
                name='Capture Area',
                description='Screenshot a custom area',
                icon='images/icon.svg',
                on_enter=ExtensionCustomAction(
                    ({'action': 'screenshot_area'}), True),
            ),
            ExtensionResultItem(
                name='Capture Window',
                description='Screenshot an application window',
                icon='images/icon.svg',
                on_enter=ExtensionCustomAction(
                    ({'action': 'screenshot_window'}), True),
            ),
            ExtensionResultItem(
                name='Capture Monitor',
                description='Screenshot an active display',
                icon='images/icon.svg',
                on_enter=ExtensionCustomAction(
                    ({'action': 'screenshot_monitor'}), True),
            ),
            ExtensionResultItem(
                name='Color Picker',
                description='Copy the hex color of a pixel',
                icon='images/color_picker_icon.svg',
                on_enter=ExtensionCustomAction(
                    ({'action': 'color_picker'}), False),
            )
        ]

        return RenderResultListAction(menu)


if __name__ == '__main__':
    Wayshot().run()


# Swappy commands for future reference #
# avoided because the final image was so smol

# *Screenshot active Monitor
# 'grim -g "$(swaymsg -t get_outputs | jq -r \'.. | select(.active?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"\' | slurp)" - | swappy -f -'

# *Screenshot active window
# 'grim -g "$(swaymsg -t get_tree | jq -r \'.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"\' | slurp)" - | swappy -f -'

# *Screenshot drag&drop area
# 'grim -g "$(slurp)" - | swappy -f -'
