{ inputs, ... }:

{
  # Helium isn't packaged in nixpkgs, so we pull a community flake
  # (oxcl/nix-flake-helium-browser). It patchelfs upstream's prebuilt
  # .deb releases and exposes a first-class `programs.helium` NixOS module.
  # The flake input is auto-bumped upstream; `nix flake update helium` to pull newer vers.
  imports = [
    inputs.helium.nixosModules.default
  ];

  programs.helium = {
    enable = true;
    flags = [
      # auto = use Wayland (Plasma 6 session) when available, fall back to X11.
      "--ozone-platform-hint=auto"
      "--start-maximized"
    ];
    policies = {
      DefaultBrowserSettingEnabled = false; # kill the "make Helium default" nag
      MetricsReportingEnabled = false; # no telemetry
      RestoreOnStartup = 1; # reopen last session
    };
  };

  # Make Helium the system-wide default browser.
  # This writes the associations into /etc/xdg/mimeapps.list so URLs and HTML files
  # open in Helium across desktop environments that honour these.
  xdg.mime.defaultApplications = {
    "text/html" = "helium.desktop";
    "x-scheme-handler/http" = "helium.desktop";
    "x-scheme-handler/https" = "helium.desktop";
    "x-scheme-handler/about" = "helium.desktop";
    "x-scheme-handler/unknown" = "helium.desktop";
  };

  # Apps that read $BROWSER (terminal tools, etc.) launch Helium.
  environment.sessionVariables.BROWSER = "helium";
}
