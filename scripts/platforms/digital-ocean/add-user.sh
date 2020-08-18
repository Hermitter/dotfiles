#!/bin/bash
read -p "Enter Username: " username
read -p "Grant Sudo Privileges? (Y/N): " giveSudo && [[ $giveSudo == [yY] || $giveSudo == [yY][eE][sS] ]] || unset giveSudo

# confirm creation
echo -e "\n*************************"
echo -e "Username: $username\nSudo Privileges: $giveSudo"
echo -e "*************************\n"
read -p "Create This User? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

#################
## CREATE USER ##
#################
adduser $username
if ! [ -z "$giveSudo" ]; then
    usermod -aG sudo $username
fi

mkdir -p /home/$username/Desktop
mkdir -p /home/$username/Downloads
mkdir -p /home/$username/Documents

# enable external access (ssh key)
rsync --archive --chown=$username:$username ~/.ssh /home/$username

# enable firewall
ufw allow OpenSSH
ufw enable