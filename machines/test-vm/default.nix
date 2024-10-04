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
      dejavu_fonts
      fira-code
      fira-code-symbols
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      noto-fonts-emoji
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" ];
      };
      subpixel = { lcdfilter = "light"; };
    };
  };

  system.stateVersion = "24.05";
}
