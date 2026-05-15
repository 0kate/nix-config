{ pkgs, pkgsUnstable, ... }:
let
  # starship
  starshipSettings = import ./starship/settings.nix;

  # ghostty
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

  xdg.configFile = {
    "ghostty/config".source = ghosttyFormat.generate "ghostty-config" ghosttySettings;
  };

  home = {
    stateVersion = "25.11";
    username = "okate";
    homeDirectory = "/home/okate";
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      hackgen-nf-font
      udev-gothic-nf

      pkgsUnstable.claude-code
      pkgsUnstable.devbox
      difftastic
      direnv
      eza
      fzf
      # gnomeExtensions.bluetooth-battery-meter
      # gnomeExtensions.clipboard-indicator
      # gnomeExtensions.dash-to-dock
      # gnomeExtensions.paperwm
      # gnomeExtensions.kimpanel
      # gnomeExtensions.system-monitor
      lazydocker
      navi
      nil
      nixpkgs-fmt
      ripgrep
      yazi
    ];
  };
  
  services = {
    flatpak = {
      enable = true;
      packages = [
        "ca.desrt.dconf-editor"
        "com.bitwarden.desktop"
        "com.discordapp.Discord"
        "com.github.marhkb.Pods"
        "com.google.Chrome"
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
      package = pkgsUnstable.helix;
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
      "org/gnome/shell" = {
        # enabled-extensions = [
        #   "Bluetooth-Battery-Meter@maniacx.github.com"
        #   "clipboard-indicator@tudmotu.com"
        #   "dash-to-dock@micxgx.gmail.com"
        #   "kimpanel@kde.org"
        #   "paperwm@paperwm.github.com"
        #   "pomodoro@arun.codito.in"
        #   "system-monitor@gnome-shell-extensions.gcampax.github.com"
        # ];
        # "extensions/paperwm/keybindings" = {
        #   switch-next = "[ '<Super>period' '<Alt>d' '<Super>d' ]";
        #   switch-previous = "[ '<Super>comma' '<Alt>s' '<Super>s' ]";
        # };
      };
      "org/gnome/TextEditor" = {
        "keybindings" = "vim";
      };
    };
  };
}
