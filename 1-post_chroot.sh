#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
configFileName=$SCRIPT_DIR/preferences.conf
. $configFileName

# Hostname
# Set hostname
if [ -e "$configFileName" ] && [ ! -z "$hostname" ]; then
	echo "hostname: $hostname"
else
	read -p "Please name your machine:" hostname
	echo "hostname=$hostname" >> $configFileName
fi
echo $hostname > /etc/hostname

# Set hosts file.
cat <<EOF > /etc/hosts
127.0.0.1   localhost
::1         localhost
127.0.1.1   $hostname.localdomain   $hostname
EOF


# Needed packages
pacman -S --noconfirm --needed grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober mtools dosfstools base-devel linux-headers get reflector bluez bluez-utils pulseaudio-bluetooth xdg-utils xdg-user-dirs python3


# Microcode
proc_type=$(lscpu | awk '/Vendor ID:/ {print $3}')
case "$proc_type" in
	GenuineIntel)
		echo "Installing Intel microcode"
		pacman -S --noconfirm intel-ucode
		proc_ucode=intel-ucode.img
		;;
	AuthenticAMD)
		echo "Installing AMD microcode"
		pacman -S --noconfirm amd-ucode
		proc_ucode=amd-ucode.img
		;;
esac	

# Graphics drivers
if lspci | grep -E "NVIDIA|GeForce"; then
	echo "Installing NVIDIA Drivers."
        pacman -S nvidia --noconfirm --needed
	nvidia-xconfig
elif lspci | grep -E "Radeon"; then
        echo "Installing ATI/AMD Drivers."
	pacman -S xf86-video-amdgpu --noconfirm --needed
elif lspci | grep -E "Integrated Graphics Controller"; then
        echo "Installing Intel Integrated Drivers."
        pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils --needed --noconfirm
fi


# mkinitcpio
sed -i 's/#.*HOOKS=(/placeholder/' /etc/mkinitcpio.conf																						# Replaces all commented hooks with a placeholder so the next command won't uncomment all of them
sed -i '/HOOKS=(/c\HOOKS=(base udev autodetect keymap modconf block encrypt lvm2 filesystems keyboard fsck)' /etc/mkinitcpio.conf			# Edit hooks
sed -i 's/placeholder/#    HOOKS=(/' /etc/mkinitcpio.conf																					# Replace placeholder with originals
sleep 1
mkinitcpio -P


# Install Grub																										# Install grub
if [[ ! -d "/sys/firmware/efi" ]]; then
echo "Detected BIOS"
#    grub-install --target=i386-pc ${disk}
    echo "-------------------------------------------------------------------------"
    echo "--                BIOS system not currently supported!                 --"
    echo "--                            End of script                            --"
    echo "-------------------------------------------------------------------------"
    exit 0
fi
if [[ -d "/sys/firmware/efi" ]]; then
    echo "Detected EFI"
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=${hostname}_grub
fi

# This assumes that partition 2 is the LVM partition. It should be if the disk is zapped and properly parted.
# edits /etc/default/grub																							# edits cfg
lvmuuid=$(blkid -s UUID -o value /dev/sda2)
DefaultGrub="GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=${lvmuuid}:cryptLVM root=/dev/vg1/root\""	
python3 $SCRIPT_DIR/Replace_Line.py -r GRUB_CMDLINE_LINUX= -d /etc/default/grub -i "${DefaultGrub}"
grub-mkconfig -o /boot/grub/grub.cfg