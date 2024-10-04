{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

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

    mkSystem = import ./lib/mkSystem.nix {
      inherit nixpkgs overlays inputs;
    };
  in {
    nixosConfigurations.test-vm = mkSystem "test-vm" {
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
