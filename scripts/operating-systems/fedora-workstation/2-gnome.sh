# Install GTK theme and Flatpak theme
sudo dnf install -y flat-remix-icon-theme materia-gtk-theme gnome-shell-extension-material-shell 
flatpak install -y flathub org.gtk.Gtk3theme.Materia{,-dark,-light}{,-compact}

# Install GNOME extentions
sudo dnf install -y gnome-shell-extension-dash-to-dock gnome-shell-extension-appindicator.noarch gnome-shell-extension-user-theme

# Change theme settings
gsettings set org.gnome.desktop.interface gtk-theme "Materia-dark-compact"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
gsettings set org.gnome.desktop.interface cursor-size 32