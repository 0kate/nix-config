{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
    openssh
  ];

  time.timeZone = "Asia/Tokyo";

  virtualisation.docker.enable = true;
}
