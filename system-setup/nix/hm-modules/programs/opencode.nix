{
  config,
  pkgs,
  lib,
  ...
}:

{
  # TODO: add installation step
  xdg.configFile = {
    "opencode/opencode.jsonc".source = ../../../../Applications/opencode/opencode.jsonc;
    "opencode/agent" = {
      source = ../../../../Applications/opencode/agent;
      recursive = true;
    };
  };
}
