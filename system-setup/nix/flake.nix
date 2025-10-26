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
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      agenix,
      ...
    }@inputs:
    # TODO: use extraSpecialArgs to pass arguments to home-manager modules
    let
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ nur.overlays.default ];
        };
    in
    {
      nixosConfigurations = {
        # NixOS configurations + integrated home-manager module
        nixos-workstation = nixpkgs.lib.nixosSystem {
          pkgs = pkgsFor "x86_64-linux";
          modules = [
            ./hosts/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit agenix; };
                users.murtadha = ./hosts/desktop/home.nix;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        # Standalone home-manager configurations for macOS
        "murtadha@MacBookPro.localdomain" = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor "aarch64-darwin";
          modules = [
            ./hosts/macOS/home.nix
            agenix.homeManagerModules.default
          ];
        };
      };
    };
}
