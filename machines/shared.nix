{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
  ];

  time.timeZone = "Asia/Tokyo";

  virtualisation.docker.enable = true;
}
