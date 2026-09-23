# Login shells only, which is also how GUI apps (VS Code, Zed) read the user environment.
# PATH is built here rather than in .zshenv because /etc/zprofile's path_helper runs in
# between and would push these entries behind the system ones.

[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

typeset -U path
path=(
  "$XDG_BIN_HOME" # `uv tool install` CLIs, OrbStack's docker, personal scripts
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  $path
  # nix-darwin's system profile: /etc/zshrc would normally add it, but nix-darwin is kept
  # out of the system shell files (darwin-modules/shells.nix)
  /run/current-system/sw/bin
)

# Nix profiles. Determinate hooks only /etc/zshrc, which non-interactive shells skip, and
# its guard makes it a no-op in shells whose parent already ran it, even after path_helper
# has moved the Nix entries behind the system ones. Clearing the guard re-prepends them.
if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  unset __ETC_PROFILE_NIX_SOURCED
  source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# mise tools for non-interactive login shells (editors); .zshrc's full activation takes
# precedence in interactive ones.
(( $+commands[mise] )) && eval "$(mise activate zsh --shims)"

# OrbStack re-adds its PATH hook to this file unless the (commented) line below is present.
# source ~/.orbstack/shell/init.zsh 2>/dev/null || :
