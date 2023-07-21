#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Read config file, error if it exists
configFileName=$SCRIPT_DIR/preferences.conf
if [ -e "$configFileName" ]; then
	echo "Configuration file preferences.conf already exists."
    read -p "Remake config? [Y/n]: " answer
    # Convert the answer to lowercase for case-insensitive comparison
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
    # Check the user's response
    if [ "$answer" = "y" ]; then
        # Perform the deletion
        rm $configFileName
    else
        exit
    fi
fi


# Set hostname
read -p "Please name your machine: " hostname
echo "hostname=\"$hostname\"" >> $configFileName

# Set crypt device name
read -p "Please name your crypt device: " crypt_device
echo "crypt_device=\"$crypt_device\"" >> $configFileName

# Set vg name
read -p "Please name your volume group: " volume_group_name
echo "volume_group_name=\"$volume_group_name\"" >> $configFileName

# Set grub name
read -p "Please name grub: " grub_name
echo "grub_name=\"$grub_name\"" >> $configFileName


# Get username
read -p "Please enter username: " username
echo "username=\"$username\"" >> $configFileName

# Get passwd
while true; do
    read -p "Password for $username: " userpass
    read -p "Verify password for $username : " userpass2
    if [ "$userpass" = "$userpass2" ] && [ "$userpass" != "" ]; then
        break
    fi
echo "Please try again"
done
echo "userpass=\"$userpass\"" >> $configFileName

# Get root passwd
while true; do
    read -p "Password for root: " rootpass
    read -p "Verify password for root : " rootpass2
    if [ "$rootpass" = "$rootpass2" ] && [ "$rootpass" != "" ]; then
        break
    fi
echo "Please try again"
done
echo "rootpass=\"$rootpass\"" >> $configFileName


echo ""
echo ""