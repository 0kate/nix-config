{ pkgs, config, lib, ... }:
let
  # GNOME extensions
  enabledGnomeExtensions = [
    "Bluetooth-Battery-Meter@maniacx.github.com"
    "clipboard-indicator@tudmotu.com"
    "dash-to-dock@micxgx.gmail.com"
    "kimpanel@kde.org"
    "paperwm@paperwm.github.com"
    "Vitals@CoreCoding.com"
  ];

  # starship
  starshipSettings = import ./starship/settings.nix;
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-mozc ];
  };
    
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" "DejaVu Sans" ];
        serif = [ "Noto Serif JP" "DejaVu Serif" ];
      };
    };
  };

  xdg = {
    enable = true;
    localBinInPath = true;
  };

  home = {
    stateVersion = "25.11";
    username = "okate";
    homeDirectory = "/home/okate";

    file = {
      ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/git/config";
      ".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/git/ignore";
    };

    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      hackgen-nf-font
      udev-gothic-nf

      blesh
      devbox
      gnome-extensions-cli
      nil
      nixpkgs-fmt
    ];

    activation = {
      installGnomeExtensions = config.lib.dag.entryAfter ["writeBoundary"] ''
        export PATH=$PATH:${pkgs.gnome-extensions-cli}/bin

        ${lib.concatMapStringsSep "\n" (uuid: ''
          if [ ! -d "$HOME/.local/share/gnome-shell/extensions/${uuid}" ]; then
            echo "Installing GNOME Extension: ${uuid}"
            gext install "${uuid}" || echo "Failed to install ${uuid}, skipping..."
          fi
        '') enabledGnomeExtensions}
      '';

    };
  };

  services = {
    flatpak = {
      enable = true;
      packages = [
        "ca.desrt.dconf-editor"
        "com.bitwarden.desktop"
        "com.github.marhkb.Pods"
        "com.github.tchx84.Flatseal"
        "com.github.tenderowl.frog"
        "com.google.Chrome"
        "com.mattjakeman.ExtensionManager"
        "com.slack.Slack"
        "me.iepure.devtoolbox"
        "org.gnome.Builder"
        "org.gnome.Extensions"
        "org.gnome.World.Iotas"
        "org.gnome.seahorse.Application"
      ];
    };
  };

  programs = {
    home-manager = {
      enable = true;
    };

    bash = {
      enable = true;
      enableVteIntegration = true;

      bashrcExtra = ''
        [[ $- == *i* ]] && source -- ${pkgs.blesh}/share/blesh/ble.sh --attach=none
        [[ ! $BLE_VERSION- ]] || ble-attach
      '';

      shellAliases = {
        jjp = "jj --config=ui.paginate=auto";
      };
    };

    difftastic = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };

    claude-code = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = starshipSettings;
    };

    navi = {
      enable = true;
      enableBashIntegration = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      icons = "auto";
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };

    git = {
      enable = true;
      settings = {    
        user = {
          name = "keito-osaki";
          email = "o.keito317@gmail.com";
        };
      };
      ignores = [
        ".envrc"
        ".direnv"
        ".claude/settings.local.json"
      ];
    };

    jujutsu = {
      enable = true;
      settings = {
        user = {
          name = "0kate";
          email = "o.keito317@gmail.com";
        };
        ui = {
          paginate = "never";
          pager = ":builtin";
          default-command = "log";
          diff-formatter = "difft";
        };
      };
    };

    rclone = {
      enable = true;
    };

    vim = {
      enable = true;
      defaultEditor = true;
      packageConfigurable = pkgs.vim;
      settings = {
        number = true;
      };
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        clock-format = "24h";
        gtk-key-theme = "Emacs";
        show-battery-percentage = true;
      };
      "org/gnome/desktop/input-sources" = {
        sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "us" ]) ];
        xkb-options = [ "ctrl:swapcaps" ];
      };
      "org/gnome/shell" = {
        enabled-extensions = enabledGnomeExtensions;
        favorite-apps = [
          "org.gnome.Calendar.desktop"
          "org.gnome.Nautilus.desktop"
          "org.gnome.Settings.desktop"
          "org.gnome.Software.desktop"
          "com.google.Chrome.desktop"
          "com.slack.Slack.desktop"
          "org.gnome.Ptyxis.desktop"
          "org.gnome.Builder.desktop"
          "com.github.marhkb.Pods.desktop"
          "org.gnome.World.Iotas.desktop"
        ];
      };
      "org/gnome/shell/extensions/paperwm" = {
        default-focus-mode = 1;
        horizontal-margin = 20;
        selection-border-radius-bottom = 10;
        selection-border-radius-top = 10;
        selection-border-size = 8;
        show-window-position-bar = false;
        show-workspace-indicator = false;
        vertical-margin = 16;
        vertical-margin-bottom = 16;
        window-gap = 18;
      };
      "org/gnome/shell/extensions/paperwm/keybindings" = {
        switch-left = [ "<Alt>s" ];
        switch-right = [ "<Alt>d" ];
      };
      "org/gnome/mutter" = {
        attach-modal-dialogs = false;
        edge-tiling = false;
        workspaces-only-on-primary = false;
      };
      "org/gnome/Ptyxis" = {
        font-name = "HackGen Console NF 12";
        use-system-font = false;
      };
      "org/gnome/shell/extensions/vitals" = {
        alphabetize = true;
        fixed-widths = true;
        hot-sensors = [ "_memory_usage_" "_processor_usage_" "__network-tx_max__" "__network-rx_max__" ];
        icon-style = 1;
        menu-centered = true;
        show-battery = true;
        show-gpu = true;
        use-higher-precision = false;
      };
    };
  };
}
