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
    kernelParams = [
      "i915.force_probe=7d45"
      "i915.enable_guc=2"
    ];
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

  environment.systemPackages = with pkgs; [
    cassandra
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
    gnome.gnome-keyring
    gnome.gnome-tweaks
    gnomeExtensions.bluetooth-battery-meter
    gnomeExtensions.dash-to-dock
    gnomeExtensions.paperwm
    gnomeExtensions.tailscale-status
    gnomeExtensions.kimpanel

    ## Packages for Plasma desktop
    # kdePackages.yakuake
    # ktailctl
    # plasma-browser-integration
  ];

  services.xserver = {
    enable = true;

    xkb = {
      layout = "us";
      options = "ctrl:nocaps";
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  # services.displayManager.defaultSession = "plasmax11";
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = false;
  # services.desktopManager.plasma6.enable = true;
  # programs.partition-manager.enable = true;

  # services.touchegg.enable = true;

  hardware.bluetooth.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.tailscale.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      intel-media-driver
    ];
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
      hackgen-nf-font
      nerdfonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-extra
      noto-fonts-emoji
      udev-gothic-nf
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

  programs.java = {
    enable = true;
    package = pkgs.corretto21;
  };

  system.stateVersion = "24.05";
}
