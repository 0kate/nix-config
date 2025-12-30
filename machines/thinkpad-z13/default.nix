{ pkgs, ... }:
{
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };

  networking = {
    hostName = "ThinkPad-Z13";
    networkmanager = {
      enable = true;
      # Disable internal DNS resolution
      dns = "none";
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  security = {
    rtkit.enable = true;
  };

  environment = {
    variables = {
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
    };
    systemPackages = with pkgs; [
      cassandra
      clamav
      clamtk
      devbox
      devenv
      dig
      gnumake
      gradle
      lsof
      maven
      mysql84
      tailscale
      traceroute
      touchegg

      ## Packages for GNOME desktop
      dconf-editor
      gnome-keyring
      gnome-tweaks
      gnomeExtensions.bluetooth-battery-meter
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.paperwm
      gnomeExtensions.tailscale-status
      gnomeExtensions.kimpanel
      libgtop
    ];
    localBinInPath = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    clamav = {
      daemon.enable = true;
      scanner.enable = true;
      updater.enable = true;
    };

    pulseaudio = {
      enable = false;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    tailscale = {
      enable = false;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      jetbrains-mono
      hackgen-nf-font
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      udev-gothic-nf
    ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts.hack);
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
