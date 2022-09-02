# Notes about Dotfiles

- See what other existing dot files can be included in the setup script file (example the remaining ZSH files).

- Try to run the whole install script in head and in reality for testing purposes.

- Somehow create a script for the .pyenv installation to install the latest version of Python and set it as the global Python, and install the latest version of Anaconda and possibly create a virtual envrionment for it (with pyenv-virtualenv).

  - Also install with pip to the 'global' version of Python in pyenv the packages used by vscode: autopep8 and pylint.
  - The instructions for settings up and using pyenv-virtualenv: https://github.com/pyenv/pyenv-virtualenv
  - Example use-case scenario by me: https://stackoverflow.com/questions/57640272/how-can-i-install-anaconda-aside-an-existing-pyenv-installation-on-osx/73139031#73139031

- Setup SSH keys for Github.

- Create private Github repos for backing up both Obsidian valuts and the Projects folder in the home directory. Same thing for backing up the Zotero folder in the home directory.

- Jetbrains Toolbox App will set the 'Tools' install location to the following by default: /Users/murtadha/Library/Application Support/JetBrains/Toolbox
- The Jetbrains Toolbox App sets the following location for shell scripts: /Users/murtadha/Library/Application Support/JetBrains/Toolbox/scripts
- These locations might change if the Toolbox App was installed with Homebrew.
- Pay special attention to that fact when it comes to the location of the shell scripts, as this location above is included in the PATH array in ZSHRC (if the Toolbox App is installed with Homebrew this location might be different and hence the directory included in PATH in ZSHRC need to change accordingly).
- (should I change the location of the shell scripts --like moving it to ~/JetBrainsScripts-- and include it in the .dotfiles directory?)

## Notes about the operation of dotbot

- Link: https://github.com/anishathalye/dotbot

- install.conf.yaml
  - Note: If the source location is omitted for links or it's set to `null` Dotbot will use the base name of the destination, with the leading `.` stripped if present.

## Notes about the operation of mas

- Link: https://github.com/mas-cli/mas
