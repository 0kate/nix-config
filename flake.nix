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
    user = "okate";
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    wslConfig  = ./machines/wsl.nix;
    # vmX8664Config  = ./machines/x86_64.nix;
    testVMConfig   = ./machines/test-vm;
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
        # vmX8664Config
        testVMConfig
        userOSConfig
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${user} = import userHomeConfig {
            inputs = inputs;
            isWSL  = false;
          };
        }
      ];

      specialArgs = {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default
        {
          nixpkgs.overlays = overlays;
        }
        wslConfig
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
