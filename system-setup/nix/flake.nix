{
  description = "Workstation Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
      ...
    }@inputs:
    {
      nixosConfigurations = {
        # NixOS configurations + integrated home-manager module
        nixos-workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/configuration.nix

            # Configure nixpkgs through the module system
            # NOTE: we aren't abstracting `pkgs` with something like `pkgsFor` function based on system
            # architecture because NixOS-integrated HM with useGlobalPkgs expects module-based nixpkgs config
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ nur.overlays.default ];
            }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "hm-bkp"; # TODO: research the difference from backupCommand
                extraSpecialArgs = { inherit inputs; };
                users.murtadha = ./hosts/desktop/home.nix;
              };
            }
          ];
        };
      };

      homeConfigurations = {
        # Standalone home-manager configuration for macOS
        "murtadha@MacBookPro.localdomain" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config.allowUnfree = true;
            overlays = [ nur.overlays.default ];
          };
          modules = [
            ./hosts/macOS/home.nix
          ];
        };
      };
    };
}
