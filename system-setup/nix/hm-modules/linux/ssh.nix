{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.ssh;
in
# Linux-only: services.ssh-agent and systemd.user.sessionVariables don't exist
# on macOS (where the system ssh-agent + keychain integration is used instead).
# TODO: configure on macos and turn into a cross-platform HM module
{
  options.dotfiles.ssh = {
    enable = lib.mkEnableOption "SSH client with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # Attribute names become `Host <name>` patterns; values are literal
      settings = {
        "*".AddKeysToAgent = "yes";
        "github.com".IdentityFile = "~/.ssh/keys/github";
      };
    };

    services.ssh-agent.enable = true;

    systemd.user.sessionVariables = {
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/ssh-agent";
    };
  };
}
