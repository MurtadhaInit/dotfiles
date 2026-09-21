{ config, lib, ... }:

let
  cfg = config.dotfiles.defaultShell;
in
{
  options.dotfiles.defaultShell = {
    enable = lib.mkEnableOption "management of an existing user's login shell";
    user = lib.mkOption {
      type = lib.types.strMatching "[a-zA-Z_][a-zA-Z0-9_.-]*";
      description = "Existing macOS account whose login shell to configure.";
    };
    shellPath = lib.mkOption {
      type = lib.types.strMatching "/[^\n\r]+";
      example = "/opt/homebrew/bin/nu";
      description = "Stable absolute executable path. Install the shell separately.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.shells = [ cfg.shellPath ]; # added to /etc/shells

    # users.users.<name>.shell only updates accounts in users.knownUsers, which
    # also grants account creation/deletion ownership. Only change UserShell here.
    # postActivation runs after /etc/shells (and any nix-darwin Homebrew setup).
    system.activationScripts.postActivation.text = lib.mkAfter ''
      defaultShellPath=${lib.escapeShellArg cfg.shellPath}
      defaultShellRecord=${lib.escapeShellArg "/Users/${cfg.user}"}
      if [ ! -x "$defaultShellPath" ]; then
        printf >&2 'warning: login shell unchanged for %s: %s is not executable. Install it and re-run darwin-rebuild switch.\n' ${lib.escapeShellArg cfg.user} "$defaultShellPath"
      else
        defaultShellCurrent=$(/usr/bin/dscl . -read "$defaultShellRecord" UserShell)
        if [ "$defaultShellCurrent" != "UserShell: $defaultShellPath" ]; then
          echo "setting login shell for ${cfg.user}..." >&2
          /usr/bin/dscl . -create "$defaultShellRecord" UserShell "$defaultShellPath"
        fi
      fi
    '';
  };
}
