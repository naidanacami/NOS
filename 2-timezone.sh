#!/bin/bash

timezone=curl https://ipapi.co/timezone

echo "Detected timezone: ${timezone}"


read -p "Is this correct? [Y/n] " choice
choice=${choice,,}
if [ "$choice" != "y" ]; then
    exit 0
fi

# Set time
timedatectl --no-ask-password set-ntp 1
timedatectl --no-ask-password set-timezone $timezone
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
