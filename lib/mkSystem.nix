{ nixpkgs, overlays, inputs }:
name:
{ system, user, wsl ? false }:
let
  isWSL = wsl;

  machineConfig   = ../machines/${name};
  userHomeConfig = ../users/${user}/home.nix;
  userOSConfig   = ../users/${user}/nixos.nix;

  home-manager = inputs.home-manager;
in nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    { nixpkgs.overlays = overlays; }
    { nixpkgs.config.allowUnfree = true; }
    machineConfig
    userOSConfig
    home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHomeConfig {
        inputs = inputs;
        isWSL  = isWSL;
      };
    }
  ];
}
