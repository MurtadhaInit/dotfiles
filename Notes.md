# Notes about Dotfiles

- Somehow create a script for the .pyenv installation to install the latest version of Python and set it as the global Python, and install the latest version of Anaconda and possibly create a virtual envrionment for it (with pyenv-virtualenv).

  - Also install with pip to the 'global' version of Python in pyenv the packages used by vscode: autopep8 and pylint.
  - The instructions for settings up and using pyenv-virtualenv: https://github.com/pyenv/pyenv-virtualenv
  - Example use-case scenario by me: https://stackoverflow.com/questions/57640272/how-can-i-install-anaconda-aside-an-existing-pyenv-installation-on-osx/73139031#73139031

- Setup SSH keys for Github.

- Jetbrains Toolbox App will set the 'Tools' install location to the following by default:
  /Users/murtadha/Library/Application Support/JetBrains/Toolbox
- The Jetbrains Toolbox App sets the following location for shell scripts:
  /Users/murtadha/Library/Application Support/JetBrains/Toolbox/scripts
- Should I change the location of the shell scripts? e.g. moving it to ~/JetBrainsScripts and include it in the .dotfiles directory?
- Backup the Tookbox settings? They are the files:
  /Users/murtadha/Library/LaunchAgents/com.jetbrains.toolbox.plist
  /Users/murtadha/Library/Preferences/com.jetbrains.toolbox.plist
- Can we automate the installation of JetBrains IDEs with the Toolbox app? Possibly with one of its scripts?

- Think about replacing /opt/homebrew in the setup_scripts with the variable that leades to that directory / tool (for it to be more evergreen and not hardcoded).

- Add .bash_profile (login shells) and .bashrc (interactive shells) to .dotfiles as well.
- Add .condarc?
- Explore the .config directory in Home and see if there is anything worth adding too.

- Maybe add github links for the various projects installed / used right in the ZSH config files.

  - The install script will generate the files ~/.fzf.zsh and ~/.fzf.bash which can then be sourced automatically (with the the install script) or manually.

- Extensive detailed video: https://www.youtube.com/watch?v=bTLYiNvRIVI

- Star all the github repos for the tools used.

- Try to understand `compinit` and `autoload` in zsh and the way it handles functions. Plus explore how autocompletion works (with the addition of the poetry autocompletion function in .zfunc for example).

  - Important explanation: https://unix.stackexchange.com/questions/33255/how-to-define-and-load-your-own-shell-function-in-zsh?newreg=4c14dc7278974c4aae7f8266564f9f13
  - And here: https://zsh.sourceforge.io/Doc/Release/Completion-System.html

- Possibly change `.fzf.zsh` to have $(brew --prefix) in its directories.

- Backup Automator scripts? Located in ~/Library/Services e.g. Open in VSCode

- a function "docker-cleanup" that stops and removes all containers and removes all images?

- Use Ansible instead of Dotbot?

- Find a way to have a "reserved" Python version (potentially with pyenv) for applications that depend on it like Poetry and Ansible.

- Possibly install CleanShotX from Homebrew instead.

- Periodically backup Zotero data folder with Git?

- A backup solution for larger directories that shouldn't be committed to `.dotfiles` (e.g. the Projects directory). A cloud solution?

- Include ~/.local/bin in the .dotfiles directory? It has the poetry binaries which are added to path.

- Backup all Apps settings in the form of plist files? Those mostly located in ~/Library/Preferences

- Export an environment variable for $(brew --prefix) and replace it everywhere in zsh dotfiles to avoid evaluating it everywhere.

- Save iStat Menus settings

- Backup .gitkraken folder.

## Notes about the operation of dotbot

- Link: https://github.com/anishathalye/dotbot

- install.conf.yaml
  - Note: If the source location is omitted for links or it's set to `null` Dotbot will use the base name of the destination, with the leading `.` stripped if present.

## Notes about the operation of mas

- Link: https://github.com/mas-cli/mas
