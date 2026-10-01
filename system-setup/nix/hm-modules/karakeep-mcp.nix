# Karakeep's MCP server, added to the shared servers in mcp.nix. Kept apart because its
# API key needs agenix, which only some hosts import.
{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.karakeep-mcp;
in
{
  imports = [ ./mcp.nix ];

  options.dotfiles.karakeep-mcp = {
    enable = lib.mkEnableOption "the Karakeep MCP server";
  };

  config = lib.mkIf cfg.enable {
    # Explicit static path: HM agenix's default contains a shell variable, which would
    # land unexpanded in the generated MCP configs.
    age.secrets.karakeep-api-key = {
      file = ../secrets/karakeep-api-key.age;
      path = "${config.home.homeDirectory}/.local/run/agenix/karakeep-api-key";
    };

    programs.mcp.servers.karakeep = {
      command = "npx";
      args = [
        "-y"
        "@karakeep/mcp"
      ];
      env = {
        KARAKEEP_API_ADDR = "https://karakeep.k8s.murtadha.dev";
        KARAKEEP_API_KEY.file = config.age.secrets.karakeep-api-key.path;
      };
    };
  };
}
