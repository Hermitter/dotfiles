# Overview

![Extension preview image](images/preview.png)

A [Ulauncher](https://github.com/Ulauncher/Ulauncher) extension to take screenshots for [SwayWM](https://github.com/swaywm/sway).
It also includes a color picker! 

# Requirements
- `notify-send`: Screenshot notifications
- [`grim`](https://github.com/emersion/grim): Wayland screenshots
- [`slurp`](https://github.com/emersion/slurp): Region selector

# Installation
Copy this extension into the Ulauncher extensions folder.
```bash
mkdir -p ~/.local/share/ulauncher/extensions
cp wayshot ~/.local/share/ulauncher/extensions
```

Stop Ulauncher
```
sudo pkill ulauncher
```

Start Ulauncher
```
ulauncher
```

# Credits
- color picker icon: [freepick](https://www.flaticon.com/free-icon/color-picker_2547487?term=color%20picker&page=1&position=1)