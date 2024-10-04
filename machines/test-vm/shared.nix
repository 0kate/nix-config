{ config, pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  # boot.loader.systemd-boot.consoleMode = "0";

  environment.systemPackages = with pkgs; [
    gnumake
  ];

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.guest.enable = true;
}
