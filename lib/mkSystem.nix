{ nixpkgs, overlays, inputs }:
name:
{ system, user, wsl ? false }:
let
  isWSL = wsl;

  machineConfig   = ../machines/${name};
  userHomeConfig = ../users/${user}/home.nix;
  userOSConfig   = ../users/${user}/nixos.nix;

  home-manager = inputs.home-manager;

  hardware = inputs.nixos-hardware;
in nixpkgs.lib.nixosSystem {
  inherit system;

  modules = [
    hardware.nixosModules.lenovo-thinkpad-t14
    { nixpkgs.overlays = overlays; }
    { nixpkgs.config.allowUnfree = true; }
    (if isWSL then inputs.nixos-wsl.nixosModules.default else {})
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
