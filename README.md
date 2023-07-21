# N-OS
This script completes **most** of the arch installation procedures. This is not a post-install script.

This installs an LVM on LUKS setup, using the ext4 filesystem.

# Usage
1. Install git
    ```
    pacman -Sy git
    ```
2. Clone repository
    ```
    git clone https://github.com/naidanacami/NOS
    ```
3. Run NOS.sh
    ```
    cd ./NOS
    bach ./NOS.sh
    ```
4. Follow prompts

### Other responsabilities
After reboot, run ```2-timezone.sh```. I have had problems running it automatically in chroot



# Post install.
Once again, this is not a post install script. Use my [dotfiles script](https://github.com/naidanacami/dotfiles) (wip) for the post install or do it yourself.