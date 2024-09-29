{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
  let
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    machineConfig  = ./machines/wsl.nix;
    userHomeConfig = ./users/okate/home.nix;
    userOSConfig   = ./users/okate/nixos.nix;
  in {
    nixosConfigurations.vm-x86_64 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        {
          nixpkgs.overlays = overlays;
        }
        machineConfig
        userOSConfig
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."okate" = import userHomeConfig {
            inputs = inputs;
            isWSL  = false;
          };
        }
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        {
          nixpkgs.overlays = overlays;
        }
        machineConfig
        userOSConfig
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."okate" = import userHomeConfig {
            inputs = inputs;
            isWSL  = true;
          };
        }
      ];
    };
  };
}
