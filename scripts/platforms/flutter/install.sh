# Not Fully Tested Yet #
FLUTTER_DIR=$HOME/Documents/flutter/bin/flutter 

# Assumes you'll use the Android Studio flatpak 

# Install Flutter in ~/Documents folder
git clone git@github.com:flutter/flutter.git -b stable --depth 1 $HOME/Documents/flutter
$FLUTTER_DIR # set up sdk
$FLUTTER_DIR config --no-analytics
echo -e "\n# Flutter\nexport PATH=\"\$PATH:\$HOME/Documents/flutter/bin\"" >> $HOME/.profile

# Install Android Studio
flatpak install -y flathub com.google.AndroidStudio

# Configure Android Studio
$FLUTTER_DIR config --android-studio-dir=/var/lib/flatpak/app/com.google.AndroidStudio/current/active/files/extra/android-studio

echo -e "\nOpen Android Studio to configure it on your machine and then download the following:"
echo -e "  Configure > SDK Manager > SDK Tools > Android SDK Command-line Tools\n"

echo    "Finally, run the following to finish setting up Flutter:"
echo -e "  flutter doctor --android-licenses"
