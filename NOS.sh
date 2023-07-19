#!/bin/bash

echo -ne "
   ▄   ████▄    ▄▄▄▄▄   
    █  █   █   █     ▀▄ 
██   █ █   █ ▄  ▀▀▀▀▄   
█ █  █ ▀████  ▀▄▄▄▄▀    
█  █ █                  
█   ██                  

     Arch Installer     
"

status=$?
bash make_config.sh
cmd="bash 0-pre_chroot.sh"
$cmd

status=$? && [ $status -eq 0 ] || exit
arch-chroot /mnt /bin/bash /home/NOS/1-post_chroot.sh

echo -ne "
   ▄   ████▄    ▄▄▄▄▄   
    █  █   █   █     ▀▄ 
██   █ █   █ ▄  ▀▀▀▀▄   
█ █  █ ▀████  ▀▄▄▄▄▀    
█  █ █                  
█   ██                  

     Script Complete     
"

echo "-------------------------------------------------------------------------"
echo "--               Please complete post-chroot duties!                   --"
echo "-------------------------------------------------------------------------"