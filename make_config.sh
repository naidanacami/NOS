#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Read config file, error if it exists
#configFileName=${HOME}/NaidaArch/install.conf
configFileName=$SCRIPT_DIR/install.conf
if [ -e "$configFileName" ]; then
	echo "Configuration file install.conf already exists."
    read -p "Remake config? [Y/n]: " answer
    # Convert the answer to lowercase for case-insensitive comparison
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
    # Check the user's response
    if [ "$answer" = "y" ]; then
        # Perform the deletion
        rm $(configFileName)
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
