print "Setting up a MacOS machine..."

use utils/utils.nu ensure_homebrew_package

source tasks/setup-dirs.nu
source tasks/setup-zsh.nu
source tasks/essentials.nu