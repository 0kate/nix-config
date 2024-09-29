{ pkgs, ... }:
{
  imports = [
    ./shared.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # VMware, Parallels both only support this being 0 otherwise you see
  # "error switching console mode" on boot.
  boot.loader.systemd-boot.consoleMode = "0";

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.plasma5.enable = true;
    displayManager.sddm.enable = true;
  };

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      fira-code
      jetbrains-mono
    ];
  };

  system.stateVersion = "24.05";
}
