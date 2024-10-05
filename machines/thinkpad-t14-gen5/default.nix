{ pkgs, ... }:
{
  imports = [
    <nixos-hardware/lenovo/thinkpad/t14>
    ../shared.nix
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  environment.systemPackages = with pkgs; [
    gnumake
    wpa_supplicant
  ];

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];
    xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };
    desktopManager.lxqt.enable = true;
  };
  services.displayManager.sddm.enable = true;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  fonts = {
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
    fontDir.enable = true;
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
