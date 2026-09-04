{
  description = "Workstation Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: switch to a (better, consistent) `follows` once that issue is addressed upstream
    # Deliberately not following nixpkgs: nix-darwin master currently builds its HTML
    # manual with a `--sidebar-depth` flag that nixos-unstable's nixos-render-docs has
    # dropped, which fails the whole system build. Its own pin is the one it is tested
    # against, and this config installs no packages, so the split costs nothing.
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    # Determinate owns the Nix installation on macOS; its module is what stops
    # nix-darwin from fighting it over /etc/nix. Pinned through the documented FlakeHub
    # URL to the same major line as the installed Determinate Nix.
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
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
    openlogi = {
      url = "github:AprilNEA/OpenLogi";
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
      nix-darwin,
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

      darwinConfigurations = {
        # macOS system-level configuration.
        # The user environment is configured via standalone home-manager (below).
        macbookpro = nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.config = nixpkgsConfig;
              nixpkgs.overlays = nixpkgsOverlays;
            }

            ./hosts/macos/darwin.nix
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

        # Standalone home-manager configuration for a general-purpose Ubuntu server VM
        "murtadha@ubuntu-vm" = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = { inherit inputs; };
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config = nixpkgsConfig;
            overlays = nixpkgsOverlays;
          };
          modules = [
            ./hosts/ubuntu-vm/home.nix
          ];
        };
      };
    };
}
