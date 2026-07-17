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
    devbox = {
      url = "github:jetify-com/devbox";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      # shared nixpkgs configuration across hosts to avoid drift
      nixpkgsConfig = {
        allowUnfree = true;
      };
      nixpkgsOverlays = [ nur.overlays.default ];
    in
    {
      nixosConfigurations = {
        # NixOS configurations + integrated home-manager module
        nixos-workstation = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop

            # NOTE: NixOS-integrated HM with useGlobalPkgs expects module-based nixpkgs config
            {
              nixpkgs.config = nixpkgsConfig;
              nixpkgs.overlays = nixpkgsOverlays;
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
        murtadha = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
            config = nixpkgsConfig;
            overlays = nixpkgsOverlays;
          };
          modules = [
            ./hosts/macos/home.nix
          ];
        };
      };
    };
}
