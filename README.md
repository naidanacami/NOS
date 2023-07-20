# N-OS
This script completes **most** of the arch installation procedures. This is not a post-install script.

This installs an LVM on LUKS setup, using the ext4 filesystem.

# Usagea
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
This script leaves a few things out of the installation process. You must:
1. [Set the timedate and locale](https://youtu.be/kD3WC-93jEk?t=685)
2. [Add root passwd, and user acc and configure sudo wheel privileges](https://youtu.be/kD3WC-93jEk?t=1209)


# Post install.
Once again, this is not a post install script. Use my [dotfiles script](https://github.com/naidanacami/dotfiles) (wip) for the post install or do it yourself.