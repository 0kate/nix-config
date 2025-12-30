{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    devenv.url = "github:cachix/devenv";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      overlays = [
        (final: prev: rec {
          helix = pkgsUnstable.helix;
          claude-code = pkgsUnstable.claude-code;
          codex = pkgsUnstable.codex;
          zed-editor = pkgsUnstable.zed-editor;
        })
      ];

      mkSystem = import ./lib/mkSystem.nix {
        inherit nixpkgs overlays inputs;
      };
    in
    {
      nixosConfigurations.test-vm = mkSystem "test-vm" {
        system = "${system}";
        user = "okate";
      };

      nixosConfigurations.private-vm = mkSystem "private-vm" {
        system = "${system}";
        user = "okate";
      };

      nixosConfigurations.thinkpad-t14-gen5 = mkSystem "thinkpad-t14-gen5" {
        system = "${system}";
        user = "okate";
      };

      nixosConfigurations.thinkpad-z13 = mkSystem "thinkpad-z13" {
        system = "${system}";
        user = "okate";
      };

      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "${system}";
        user = "okate";
        wsl = true;
      };
    };
}
