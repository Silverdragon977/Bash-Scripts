#!/bin/bash
# ===============================================
# takeUserOffline.sh
# Copies a user's website folder into /var/www/html/data,
# compresses it, and copies the archive to the clipboard
# ===============================================

# Ensure script is run as root or via sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or using sudo."
    exit 1
fi

# Get username
if [ -z "$1" ]; then
    read -p "Enter the username to take offline: " USERNAME
else
    USERNAME=$1
fi

USER_PATH="/var/www/html/$USERNAME"
DATA_DIR="/var/www/html/data"

# Check if user's folder exists
if [ ! -d "$USER_PATH" ]; then
    echo "Directory $USER_PATH does not exist."
    exit 1
fi

# Create the data folder if it doesn't exist
mkdir -p "$DATA_DIR"

# Copy the user folder into the data directory
cp -r "$USER_PATH" "$DATA_DIR/"

# Compress the copied folder
ARCHIVE_NAME="/tmp/${USERNAME}_backup.tar.gz"
tar -czf "$ARCHIVE_NAME" -C "$DATA_DIR" "$USERNAME"

# Check for xclip
if ! command -v xclip >/dev/null 2>&1; then
    echo "xclip is required to copy to clipboard. Install it with: sudo apt install xclip"
    echo "The archive has been created at $ARCHIVE_NAME instead."
    exit 0
fi

# Copy compressed archive to clipboard
xclip -selection clipboard -t application/gzip -i "$ARCHIVE_NAME"

echo "User $USERNAME has been copied to $DATA_DIR, compressed as $ARCHIVE_NAME, and copied to clipboard."
echo "You can now paste it in your local file explorer."
