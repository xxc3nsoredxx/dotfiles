# Dotfiles
Dotfiles and other related configuration files.
Emulates how my directories are setup.

# Configurations included
* bash
* i3
* i3status
* readline
* rofi
* top
* vim
* startx

# Directory overview

    home/
    +- .config/
    |  +- i3/
    |  |  +- config
    |  +- i3status/
    |  |  +- config
    |  |  +- wrapper.py
    |  +- rofi/
    |     +- config
    +- .vim/
    |  +- colors/
    |     +- molokai.vim
    +- github_helper_scripts/
    |  +- c.gitignore
    |  +- git_init.sh
    |  +- gnu_gpl
    |  +- gnu_gpl2
    +- .Xresources
    +- .bash_logout
    +- .bash_profile
    +- .bashrc
    +- .git_aliases
    +- .inputrc
    +- .toprc
    +- .vimrc
    +- .xinitrc

# Install script
This script provides an interactive way to install the files in this repo.
You can selectively pick and choose which ones you want, or you can install them all.
The default behavior is to respect existing files and not overwrite them.
Automatically exits when it detects that there are no more installation candidates.

```
Usage: ./install.sh [args]
Args:
    -f    Force
          Overwrites existing files.
    -h    Display this help
    -l    Display license info
```

Run this script from the root of the repo.
If you don't, then the script will crash at best, but ruin your system at worst.
That being said, my main motivation for this was to enable my user and root accounts to share dotfiles.
My old method was to just symlink, for example, `/root/.bashrc` to `/home/user/.bashrc`.
That's obviously a bad idea since the non-root user can do a privilege escalation by modifying `~/.bashrc` and waiting for root to log in.
It's not a _huge_ issue since I'm the only one using my computer, but it was bad practice and had to be changed.
Running the installer as root has not (noticably at least) broken my system.
