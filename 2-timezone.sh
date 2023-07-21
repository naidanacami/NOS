#!/bin/bash

timezone=$(curl https://ipapi.co/timezone)

echo "Detected timezone: ${timezone}"


read -p "Is this correct? [Y/n] " choice
choice=${choice,,}
if [ "$choice" != "y" ]; then
    exit 0
fi

# Set time
sudo timedatectl --no-ask-password set-ntp 1
sudo timedatectl --no-ask-password set-timezone $timezone
sudo ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
sudo hwclock --systohc
