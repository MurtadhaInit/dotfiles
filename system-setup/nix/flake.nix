{
  description = "Workstation Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager"; # do we need to specify the /master branch explicitly here?
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos-workstation = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/desktop/configuration.nix ];
        };
      };

      homeConfigurations = {
        murtadha = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/desktop/home.nix ];
        };
      };
    };
}
