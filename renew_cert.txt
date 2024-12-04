#!/bin/bash

# Function to print messages
print_message() {
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Function to print errors
print_error() {
    echo -e "$(date +"%Y-%m-%d %H:%M:%S") - \033[0;31mERROR:\033[0m $1" >&2
}

# Add port 80
print_message "Adding port 80 to UFW."
if sudo ufw allow 80/tcp; then
    print_message "Port 80 successfully added."
else
    print_error "Failed to add port 80 to UFW."
    exit 1
fi

# Run Certbot to renew certificates
print_message "Attempting to renew certificates using Certbot."
if sudo certbot renew --quiet; then
    print_message "Certbot renewal successful."
else
    print_error "Certbot renewal failed. Check Certbot logs for details."
    # Remove port 80 before exiting
    print_message "Removing port 80 from UFW due to Certbot failure."
    sudo ufw delete allow 80/tcp
    exit 1
fi

# Remove port 80
print_message "Removing port 80 from UFW."
if sudo ufw delete allow 80/tcp; then
    print_message "Port 80 successfully removed."
else
    print_error "Failed to remove port 80 from UFW."
    exit 1
fi

print_message "Script completed successfully."
exit 0
