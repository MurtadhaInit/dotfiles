{
  description = "Workstation Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master"; # do we need to specify the /master branch explicitly here?
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nur.overlays.default ];
      };
    in
    {
      nixosConfigurations = {
        nixos-workstation = lib.nixosSystem {
          # inherit system;
          inherit pkgs; # maybe it's possible to use this option instead...
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
