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
  };
}
