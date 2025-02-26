{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";
    thorium.url = "github:0kate/nix-thorium";
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
  let
    system = "x86_64-linux";

    overlays = [];

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
