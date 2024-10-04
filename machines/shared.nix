{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
  ];

  virtualisation.docker.enable = true;
}
