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

  # oh-my-posh
  ohMyPoshSettings = import ./oh-my-posh/settings.nix;

  # ghostty
  ghosttyVersion = "1.3.1";
  ghosttySettings = import ./ghostty/settings.nix;
  ghosttyFormat = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = pkgs.lib.generators.mkKeyValueDefault { } " = ";
  };

  # helix
  helixSettings = import ./helix/settings.nix;
  helixLanguages = import ./helix/languages.nix;
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
    configFile = {
      "ghostty/config".source = ghosttyFormat.generate "ghostty-config" ghosttySettings;
    };
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

      claude-code
      devbox
      difftastic
      direnv
      eza
      fzf
      gnome-extensions-cli
      jj-starship
      lazydocker
      navi
      nil
      nixpkgs-fmt
      ripgrep
      yazi
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
  
  systemd.user.services.integrate-ghostty = {
    Unit = {
      Description = "Install Ghostty AppImage via Gear Lever";
      After = [ "flatpak-managed-install.service" ];
      Requires = [ "flatpak-managed-install.service" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      Environment = [
        "PATH=${pkgs.curl}/bin:${pkgs.flatpak}/bin:/usr/bin:/bin"
      ];
      ExecStart = let
        script = pkgs.writeShellScript "integrate-ghostty" ''
          APP_IMAGE_FILE="Ghostty-${ghosttyVersion}-x86_64.AppImage"
          TMP_FILE="/tmp/$APP_IMAGE_FILE"
          URL="https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v${ghosttyVersion}/$APP_IMAGE_FILE"

          curl -L -sS "$URL" -o "$TMP_FILE"
          chmod +x "$TMP_FILE"
          flatpak run it.mijorus.gearlever --integrate --yes --replace "$TMP_FILE"
          rm -f "$TMP_FILE"
        '';
      in "${script}";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  services = {
    flatpak = {
      enable = true;
      packages = [
        "ca.desrt.dconf-editor"
        "com.bitwarden.desktop"
        "com.discordapp.Discord"
        "com.github.marhkb.Pods"
        "com.github.tenderowl.frog"
        "com.google.Chrome"
        "com.mattjakeman.ExtensionManager"
        "com.slack.Slack"
        "it.mijorus.gearlever"
        "me.iepure.devtoolbox"
        "md.obsidian.Obsidian"
        "org.gnome.Extensions"
        "org.gnome.seahorse.Application"
      ];
    };
  };

  programs = {
    home-manager = {
      enable = true;
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

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    # oh-my-posh = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   settings = ohMyPoshSettings;
    # };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = starshipSettings;
    };

    navi = {
      enable = true;
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
        "devbox.json"
        "devbox.lock"
        "devenv.lock"
        "devenv.local.nix"
        "devenv.nix"
        "devenv.yaml"
        "shell.nix"
        ".envrc"
        ".devenv*"
        ".direnv"
        ".pre-commit-config.yaml"
        ".venv"
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

    helix = {
      enable = true;
      defaultEditor = true;
      settings = helixSettings;
      languages = helixLanguages;
    };

    vim = {
      enable = true;
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
          "ghostty.desktop"
          "md.obsidian.Obsidian.desktop"
          "com.github.marhkb.Pods.desktop"
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
