# Notes about Dotfiles

- The instructions for settings up and using pyenv-virtualenv: https://github.com/pyenv/pyenv-virtualenv
- Example use-case scenario by me: https://stackoverflow.com/questions/57640272/how-can-i-install-anaconda-aside-an-existing-pyenv-installation-on-osx/73139031#73139031

- Jetbrains Toolbox App will set the 'Tools' install location to the following by default:
  /Users/murtadha/Library/Application Support/JetBrains/Toolbox
- The Jetbrains Toolbox App sets the following location for shell scripts:
  /Users/murtadha/Library/Application Support/JetBrains/Toolbox/scripts
- Should I change the location of the shell scripts? e.g. moving it to ~/JetBrainsScripts and include it in the .dotfiles directory?
- Backup the Tookbox settings? They are the files:
  /Users/murtadha/Library/LaunchAgents/com.jetbrains.toolbox.plist
  /Users/murtadha/Library/Preferences/com.jetbrains.toolbox.plist
- Can we automate the installation of JetBrains IDEs with the Toolbox app? Possibly with one of its scripts?

- Think about replacing /opt/homebrew in the setup_scripts with the variable that leads to that directory / tool (for it to be more evergreen and not hardcoded).

- Add .bash_profile (login shells) and .bashrc (interactive shells) to .dotfiles as well.

- Extensive detailed video: https://www.youtube.com/watch?v=bTLYiNvRIVI

- Try to understand `compinit` and `autoload` in zsh and the way it handles functions. Plus explore how autocompletion works (with the addition of the poetry autocompletion function in .zfunc for example).

  - Important explanation: https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh?newreg=4c14dc7278974c4aae7f8266564f9f13
  - And here: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

- Backup Automator scripts? Located in ~/Library/Services e.g. Open in VSCode

- a function "docker-cleanup" that stops and removes all containers and removes all images?

- Use Ansible instead of Dotbot?

- Find a way to have a "reserved" Python version (potentially with pyenv) for applications that depend on it like pipx.

- Periodically backup Zotero data folder with Git?

- A backup solution for larger directories that shouldn't be committed to `.dotfiles` (e.g. the Projects directory). A cloud solution?

- Backup all Apps settings in the form of plist files? Those mostly located in ~/Library/Preferences

- Export an environment variable for $(brew --prefix) and replace it everywhere in zsh dotfiles to avoid evaluating it everywhere.

- Save iStat Menus settings

- Backup .gitkraken folder.

- Think about what step of the installation requires restarting the shell to load the relevant rc files (exec $SHELL).

- brew tap oven-sh/bun

  - brew install bun

- To use touch ID for sudo instead of supplying the password:

  - Edit the file: `sudo nano /etc/pam.d/sudo`
  - Add beneath the first commented line: `auth sufficient pam_tid.so`
  - Careful not to misspell anything cause that will break `sudo`!
  - Also, this seems to go back to default after a system update!

- Find a way (or make sure) to discard any changes made automatically to the ZSH config files during the installation of packages or apps (e.g. Anaconda adding its load scripts...etc).

- Explore changing Anaconda configurations with .condarc and adding it to .dotfiles

- Explore and configure glow: https://github.com/charmbracelet/glow

- Installing Vagrant and running VMware Fusion 13 (not the tech preview):

  - `brew install vagrant`
  - For Qemu provider (better):
    - Install qemu: `brew install qemu`
    - `vagrant plugin install vagrant-qemu`
    - Guide: https://github.com/ppggff/vagrant-qemu
    - Working Ubuntu 22 box: https://app.vagrantup.com/perk/boxes/ubuntu-2204-arm64
    - Working Ubuntu 20 box: https://app.vagrantup.com/perk/boxes/ubuntu-20.04-arm64
    - To update: `vagrant plugin update`
  - For Parallels provider:
    - Guide: https://parallels.github.io/vagrant-parallels/docs/
  - For VMware Fusion provider:
    - `vagrant install --cask vagrant-vmware-utility`
    - `vagrant plugin install vagrant-vmware-desktop`
    - To update: `vagrant plugin update vagrant-vmware-desktop`
    - Guide: https://gist.github.com/sbailliez/2305d831ebcf56094fd432a8717bed93
    - If you get `vmrun` error then add this to the Vagrantfile:
    ```
    config.vm.provider :vmware_fusion do |v, o|
      v.gui = true
      # ...other config...
    end
    ```
  - Create a Vagrantfile and do `vagrant up`

- Explore rsync, rclone, btop, ncdu

- How we we replicate `brew unlink` for installing conflicting formulae?

- Find a way of securely backing up everything SSH, and manage Github keys in a better way + explore changing SSH port for homelab server

## Notes about the operation of dotbot

- Link: https://github.com/anishathalye/dotbot

- install.conf.yaml
  - Note: If the source location is omitted for links or it's set to `null` Dotbot will use the base name of the destination, with the leading `.` stripped if present.

## Notes about the operation of mas

- Link: https://github.com/mas-cli/mas
