# Not tested yet#
# Assumes you'll use the Android Studio flatpak 

# Install Android Studio
flatpak install -y flathub com.google.AndroidStudio

# Install Flutter in ~/Documents folder
git clone git@github.com:flutter/flutter.git -b stable --depth 1 $HOME/Documents/flutter
$HOME/Documents/flutter/bin/flutter # set up sdk
$HOME/Documents/flutter/bin/flutter config --no-analytics
echo -e "\n# Flutter\nexport PATH=\"\$PATH:\$HOME/Documents/flutter/bin\"" >> $HOME/.profile

# Set Flutter path to Android Studio
flutter config --android-studio-dir=/var/lib/flatpak/app/com.google.AndroidStudio/current/active/files/extra/android-studio

# TODO: agree to Android terms of service