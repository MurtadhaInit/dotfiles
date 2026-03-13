{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.opencode;
in
{
  options.dotfiles.opencode = {
    enable = lib.mkEnableOption "OpenCode with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    # TODO: add installation step
    xdg.configFile = {
      "opencode/opencode.jsonc".source = ../../../Applications/opencode/opencode.jsonc;
      "opencode/agent" = {
        source = ../../../Applications/opencode/agent;
        recursive = true;
      };
    };
  };
}
