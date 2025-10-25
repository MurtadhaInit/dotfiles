# Things to perform on macOS once Nix is adopted (nix-darwin)

1. Configure Nushell tools to generate their respective configs whenever they are updated (carapace, atuin, starship, and zoxide). See setup-nushell.nu
2. Adjust the fetchFromGithub in all home-manager config files to pull the repos through flake inputs instead (the current setup pins to a particular commit through the hash).
3. See if the SSH config still requires any other improvements or changes.
4. Research and understand further the use of agenix and the setup config created for fonts.
5. Remove the shared Nushell task for setting up XDG_ en vars for macOS. This is not needed anymore as I've decided to let Nushell use the default (inconvenient) location for config.
6. Organise modules by purpose in a subdirectory. E.g. modules/system/services and modules/system/programs
7. Might make every program module (or every module) toggle-able. And also add a snippet for quickly creating a Nix module with `options` and `config` and the module toggle option.
