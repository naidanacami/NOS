#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"



# User prompts
lsblk
echo "Please enter disk to work on: (example /dev/sda)"
read disk
disk="${disk,,}"
if [[ "${disk}" != *"/dev/"* ]]; then
    disk="/dev/${disk}"
fi

disk_size_bytes=$(lsblk -b -o SIZE -n -d $(disk))
disk_size_gib=$(numfmt --to=iec-i --suffix=B --format="%.1f" $disk_size_bytes)

echo "Please enter desired root (/) directory size (in GiB): (max ${disk_size_gib})"
read rootsize

while true; do
    read -p "Please enter LUKS password: " luks_password
    read -p "Verify LUKS password: " luks_password_recheck
if [ "$luks_password" = "$luks_password_recheck" ] && [ "$luks_password" != "" ]; then
    break
fi
echo "Please try again"
done



echo "THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK"
read -p "are you sure you want to continue (Y/N):" formatdisk
case $formatdisk in
    y|Y|yes|Yes|YES)
        echo "-------------------------------------------------------------------------"
        echo -e "\nFormatting ${disk}..."
        echo "-------------------------------------------------------------------------"
        # disk prep
        sgdisk -Z ${disk} # zap all on disk
        sgdisk -a 2048 -o ${disk} # new gpt disk 2048 alignment

        configFileName=$SCRIPT_DIR/preferences.conf
    	. $configFileName

        # Partitions
        sgdisk -n 1::+1500M --typecode=1:ef00 --change-name=1:'EFIBOOT' ${disk} # partition 1 (UEFI Boot Partition)
        sgdisk -n 2::-0 --typecode=2:8e00 ${disk} # partition 2 (lvm)
        echo "disk=\"$disk\"" >> $configFileName

        # LVM partitions + formatting
        if [[ ${disk} =~ "nvme" ]]; then
            mkfs.fat -F32 -n "EFIBOOT" ${disk}p1                                                       # EFIBOOT

            # LUKS for LVMROOT
            echo -n "${luks_password}" | cryptsetup luksFormat ${disk}p2 -                        # enter luks password to cryptsetup and format root partition
            echo -n "${luks_password}" | cryptsetup open --type luks ${disk}p2 ${crypt_device} -                    # open luks container
            #LVM for LVMROOT
            pvcreate /dev/mapper/${crypt_device}                                                        # To create a PV
            vgcreate ${volume_group_name} /dev/mapper/${crypt_device}
            lvcreate -L ${rootsize}G ${volume_group_name} -n root                                       # Create root
            lvcreate -l 100%FREE ${volume_group_name} -n home                                           # Create home
            # now format that container
            mkfs.ext4 /dev/${volume_group_name}/root                                                    # Format root ext4
            mkfs.ext4 /dev/${volume_group_name}/home                                                    # Format home ext4

        else
            mkfs.fat -F32 -n "EFIBOOT" ${disk}1                                                        # EFIBOOT

            # LUKS for LVMROOT
            echo -n "${luks_password}" | cryptsetup luksFormat ${disk}2 -                         # enter luks password to cryptsetup and format root partition
            echo -n "${luks_password}" | cryptsetup open --type luks ${disk}2 ${crypt_device} -                     # open luks container
            #LVM for LVMROOT
            pvcreate /dev/mapper/${crypt_device}                                                        # To create a PV
            vgcreate ${volume_group_name} /dev/mapper/${crypt_device}
            lvcreate -L ${rootsize}G ${volume_group_name} -n root                                       # Create root
            lvcreate -l 100%FREE ${volume_group_name} -n home                                           # Create home
            # now format that container
            mkfs.ext4 /dev/${volume_group_name}/root                                                    # Format root ext4
            mkfs.ext4 /dev/${volume_group_name}/home                                                    # Format home ext4

        fi
        echo "Mounting Filesystems..."
        mount /dev/${volume_group_name}/root /mnt                     # Moutning Root
        mkdir /mnt/home
        mount /dev/${volume_group_name}/home /mnt/home                # Mounting Home
        mkdir /mnt/boot
        mount -L EFIBOOT /mnt/boot                            # Mounting efi
    
        if ! grep -qs '/mnt' /proc/mounts; then
            echo "Drive is not mounted can not continue"
            echo "Rebooting in 3 Seconds ..." && sleep 1
            echo "Rebooting in 2 Seconds ..." && sleep 1
            echo "Rebooting in 1 Second ..." && sleep 1
            reboot now
        fi
    ;;
    *)
        echo "Figure out your drive situation, and try again."
        exit 1
    ;;
esac


pacstrap /mnt base linux linux-firmware neovim lvm2 --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab
cp -R ${SCRIPT_DIR} /mnt/home/NOS

echo "0-pre_chroot done!"
sleep 2