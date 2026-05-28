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
    localBinInPath = true;
  };

  home = {
    stateVersion = "25.11";
    username = "okate";
    homeDirectory = "/home/okate";

    sessionVariables = {
      NAVI_PATH = "/home/okate/.config/navi";
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
      jj-starship
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
        "it.mijorus.gearlever"
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

      bashrcExtra = ''
        [[ $- == *i* ]] && source -- ${pkgs.blesh}/share/blesh/ble.sh --attach=none

        [[ ! $BLE_VERSION- ]] || ble-attach
      '';
    };

    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      initContent = builtins.readFile ./zsh/extrarc;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        jjp = "jj --config=ui.paginate=auto";
        lgd = "lazydocker";
        lgg = "lazygit";
        lgs = "lazysql";
        ls = "eza --icons";
        yz = "yazi";
        zj = "zellij";
      };

      plugins = [
        {
          name = "zsh-autocomplete";
          src = pkgs.fetchFromGitHub {
            owner = "marlonrichert";
            repo = "zsh-autocomplete";
            rev = "24.09.04";
            sha256 = "o8IQszQ4/PLX1FlUvJpowR2Tev59N8lI20VymZ+Hp4w=";
          };
        }
      ];
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
      enableZshIntegration = true;
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = starshipSettings;
    };

    navi = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
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
      "org/gnome/TextEditor" = {
        keybindings = "vim";
      };
    };
  };
}
