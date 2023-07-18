#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Read config file, error if it exists
#configFileName=${HOME}/NaidaArch/install.conf
configFileName=$SCRIPT_DIR/install.conf
if [ -e "$configFileName" ]; then
	echo "Configuration file install.conf already exists...  Cannot continue."
    exit
fi

# Set hostname
if [ -e "$configFileName" ] && [ ! -z "$hostname" ]; then
	echo "hostname: $hostname"
else
	read -p "Please name your machine: " hostname
	echo "hostname=\"$hostname\"" >> $configFileName
fi

# Set crypt device name
if [ -e "$configFileName" ] && [ ! -z "$crypt_device" ]; then
	echo "crypt_device: $crypt_device"
else
	read -p "Please name your crypt device: " volume_group_name
	echo "crypt_device=\"$crypt_device\"" >> $configFileName
fi

# Set vg name
if [ -e "$configFileName" ] && [ ! -z "$volume_group_name" ]; then
	echo "volume_group_name: $volume_group_name"
else
	read -p "Please name your volume group: " volume_group_name
	echo "volume_group_name=\"$volume_group_name\"" >> $configFileName
fi
