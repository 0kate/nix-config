{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
  let
    overlays = [];

    mkSystem = import ./lib/mkSystem.nix {
      inherit nixpkgs overlays inputs;
    };
  in {
    nixosConfigurations.test-vm = mkSystem "test-vm" {
      system = "x86_64-linux";
      user   = "okate";
    };

    nixosConfigurations.private-vm = mkSystem "private-vm" {
      system = "x86_64-linux";
      user   = "okate";
    };

    nixosConfigurations.thinkpad-t14-gen5 = mkSystem "thinkpad-t14-gen5" {
      system = "x86_64-linux";
      user   = "okate";
    };

    nixosConfigurations.wsl = mkSystem "wsl" {
      system = "x86_64-linux";
      user   = "okate";
      wsl    = true;
    };
  };
}
