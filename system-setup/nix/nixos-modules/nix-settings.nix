{ ... }:

{
  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nix.gc = {
  #   automatic = true;
  #   dates = "weekly";
  #   options = "--delete-older-than 7d";
  # };

  # Weekly store deduplication (hardlinks identical files).
  # Complements the generation cleanup done by nh clean (see nh.nix).
  nix.optimise.automatic = true;
}
