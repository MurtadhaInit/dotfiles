# Notes about Dotfiles

- The instructions for settings up and using pyenv-virtualenv: <https://github.com/pyenv/pyenv-virtualenv>
- Example use-case scenario by me: <https://stackoverflow.com/questions/57640272/how-can-i-install-anaconda-aside-an-existing-pyenv-installation-on-osx/73139031#73139031>

- Jetbrains Toolbox App will set the 'Tools' install location to the following by default:
  /Users/murtadha/Library/Application Support/JetBrains/Toolbox
- The Jetbrains Toolbox App sets the following location for shell scripts:
  /Users/murtadha/Library/Application Support/JetBrains/Toolbox/scripts
- Should I change the location of the shell scripts? e.g. moving it to ~/JetBrainsScripts and include it in the .dotfiles directory?
- Backup the Tookbox settings? They are the files:
  /Users/murtadha/Library/LaunchAgents/com.jetbrains.toolbox.plist
  /Users/murtadha/Library/Preferences/com.jetbrains.toolbox.plist
- Can we automate the installation of JetBrains IDEs with the Toolbox app? Possibly with one of its scripts?

- Try to understand `compinit` and `autoload` in zsh and the way it handles functions. Plus explore how autocompletion works (with the addition of the poetry autocompletion function in .zfunc for example).

  - Important explanation: <https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh?newreg=4c14dc7278974c4aae7f8266564f9f13>
  - And here: <https://zsh.sourceforge.io/Doc/Release/Completion-System.html>

- Backup Automator scripts? Located in ~/Library/Services e.g. Open in VSCode

- Find a way to have a "reserved" Python version (potentially with pyenv) for applications that depend on it like pipx.

- Periodically backup Zotero data folder with Git?

- A backup solution for larger directories that shouldn't be committed to `.dotfiles` (e.g. the Projects directory). A cloud solution?

- Backup .gitkraken folder.

- To use touch ID for sudo instead of supplying the password:

  - Edit the file: `sudo nano /etc/pam.d/sudo`
  - Add beneath the first commented line: `auth sufficient pam_tid.so`
  - Careful not to misspell anything cause that will break `sudo`!
  - Also, this seems to go back to default after a system update!

- Explore changing Anaconda configurations with .condarc and adding it to .dotfiles

- Explore and configure glow: <https://github.com/charmbracelet/glow>

- Installing Vagrant and running VMware Fusion 13 (not the tech preview):

  - `brew install vagrant`
  - For Qemu provider (better):
    - Install qemu: `brew install qemu`
    - `vagrant plugin install vagrant-qemu`
    - Guide: <https://github.com/ppggff/vagrant-qemu>
    - Working Ubuntu 22 box: <https://app.vagrantup.com/perk/boxes/ubuntu-2204-arm64>
    - Working Ubuntu 20 box: <https://app.vagrantup.com/perk/boxes/ubuntu-20.04-arm64>
    - To update: `vagrant plugin update`
  - For Parallels provider:
    - Guide: <https://parallels.github.io/vagrant-parallels/docs/>
  - For VMware Fusion provider:
    - `vagrant install --cask vagrant-vmware-utility`
    - `vagrant plugin install vagrant-vmware-desktop`
    - To update: `vagrant plugin update vagrant-vmware-desktop`
    - Guide: <https://gist.github.com/sbailliez/2305d831ebcf56094fd432a8717bed93>
    - If you get `vmrun` error then add this to the Vagrantfile:

    ```shell
    config.vm.provider :vmware_fusion do |v, o|
      v.gui = true
      # ...other config...
    end
    ```

  - Create a Vagrantfile and do `vagrant up`

- Explore rsync, rclone, btop, ncdu

  - <https://rclone.org/>

- Find a way of securely backing up everything SSH, and explore changing SSH port for homelab server.

- Remove VMWare Fusion because it can't be removed
