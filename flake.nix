{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
  let
    system = "x86_64-linux";

    overlays = [
      (final: prev: rec {
        helix = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.helix;
      })
    ];

    mkSystem = import ./lib/mkSystem.nix {
      inherit nixpkgs overlays inputs;
    };
  in {
    nixosConfigurations.test-vm = mkSystem "test-vm" {
      system = "${system}";
      user   = "okate";
    };

    nixosConfigurations.private-vm = mkSystem "private-vm" {
      system = "${system}";
      user   = "okate";
    };

    nixosConfigurations.thinkpad-t14-gen5 = mkSystem "thinkpad-t14-gen5" {
      system = "${system}";
      user   = "okate";
    };

    nixosConfigurations.thinkpad-z13 = mkSystem "thinkpad-z13" {
      system = "${system}";
      user   = "okate";
    };

    nixosConfigurations.wsl = mkSystem "wsl" {
      system = "${system}";
      user   = "okate";
      wsl    = true;
    };
  };
}
