#!/bin/bash

# Check if run by root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run by root or using sudo"
    exit 1
fi
# Check if a username is provided as an argument
if [ -z "$1" ]; then
    echo "No username provided."
    read -p "Please enter a username: " USERNAME
else
    USERNAME=$1
fi

# Step 1: Add a new user with a home directory
sudo useradd -m -d /var/www/html/$USERNAME -s /bin/bash $USERNAME

# Step 2: Set a password for the new user
echo "Set password for user $USERNAME:"
sudo passwd $USERNAME

# Step 3: Move user's default home directory files (if necessary)
sudo mv /home/$USERNAME/* /var/www/html/$USERNAME/ 2>/dev/null

# Step 4: Set correct ownership for the user's directory
sudo chown -R $USERNAME:www-data /var/www/html/$USERNAME

# Step 5: Set directory permissions
sudo chmod 750 /var/www/html/$USERNAME

# Step 6: Set permissions for the index.php file
sudo touch /var/www/html/$USERNAME/index.php
sudo chmod 640 /var/www/html/$USERNAME/index.php

echo "User $USERNAME created and configured successfully."
