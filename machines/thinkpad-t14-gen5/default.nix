{ pkgs, ... }:
{
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "ThinkPad-T14-Gen5";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnumake
  ];

  programs.nm-applet.enable = true;

  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;
    desktopManager.lxqt.enable = true;

    xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

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
