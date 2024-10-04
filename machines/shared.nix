{ config, pkgs, ... }:
{
  time.timeZone = "Asia/Tokyo";

  virtualisation.docker.enable = true;
}
