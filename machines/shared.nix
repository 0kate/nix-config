{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
    openssh
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Asia/Tokyo";

  virtualisation.docker.enable = true;

  programs.nix-ld.enable = true;
}
