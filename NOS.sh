#!/bin/bash

status=$?
bash make_config.sh
cmd="bash 0-pre_chroot.sh"
$cmd

status=$? && [ $status -eq 0 ] || exit
arch-chroot /mnt /bin/bash /root/NaidaArch/1-post_chroot.sh

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