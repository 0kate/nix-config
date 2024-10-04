{ pkgs, ... }:
{
  imports = [
    ./shared.nix
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
      };
    };
  };

  virtualisation.virtualbox.guest.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    desktopManager.plasma5.enable = true;
  };
  services.displayManager.sddm.enable = true;

  fonts = {
    fontDir.enable = true;

    packages = with pkgs; [
      fira-code
      jetbrains-mono
    ];
  };

  system.stateVersion = "24.05";
}
