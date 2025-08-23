{
  description = "Workstation Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master"; # do we need to specify the /master branch explicitly here?
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
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos-workstation = lib.nixosSystem {
          inherit system;
          # inherit pkgs; # maybe this is needed...
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
