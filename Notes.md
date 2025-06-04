# Notes about Dotfiles

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

- Backup Automator scripts? Located in ~/Library/Services e.g. Open in VSCode

- Periodically backup Zotero data folder with Git?

- A backup solution for larger directories that shouldn't be committed to `.dotfiles` (e.g. the Projects directory). A cloud solution?

- To use touch ID for sudo instead of supplying the password:
  - Edit the file: `sudo nano /etc/pam.d/sudo`
  - Add beneath the first commented line: `auth sufficient pam_tid.so`
  - Careful not to misspell anything cause that will break `sudo`!
  - Also, this seems to go back to default after a system update!

- Explore and configure glow: <https://github.com/charmbracelet/glow>

- Explore rsync, rclone, btop, ncdu
  - <https://rclone.org/>

- Find a way of securely backing up everything SSH.
