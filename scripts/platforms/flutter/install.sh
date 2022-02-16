## Assumes you'll use the Android Studio flatpak ##

FLUTTER_ROOT=$HOME/.tools/flutter
FLUTTER_BIN=$FLUTTER_ROOT/bin/flutter

# Install Flutter in ~/.tools folder
mkdir -p $HOME/.tools/flutter
git clone git@github.com:flutter/flutter.git -b stable --depth 1 $HOME/.tools/flutter
$FLUTTER_BIN # set up sdk
$FLUTTER_BIN config --no-analytics
echo -e "\n# Flutter\nexport PATH=\"\$PATH:\$HOME/.tools/flutter/bin\"" >> $HOME/.profile
echo -e "export FLUTTER_ROOT=\"$HOME/.tools\"" >> $HOME/.profile

# Install Android Studio
flatpak install -y flathub com.google.AndroidStudio

# Configure Android Studio
$FLUTTER_BIN config --android-studio-dir=/var/lib/flatpak/app/com.google.AndroidStudio/current/active/files/extra/android-studio

echo -e "\nOpen Android Studio to configure it on your machine and then download the following:"
echo -e "  Configure > SDK Manager > SDK Tools > Android SDK Command-line Tools\n"

echo    "Finally, run the following to finish setting up Flutter:"
echo -e "  flutter doctor --android-licenses"
