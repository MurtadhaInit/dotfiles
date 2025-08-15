{
  description = "Murtadha's Workstation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs: {
    nixosConfigurations = {
      murtadha = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          # ./modules/apps.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
