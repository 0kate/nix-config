{ inputs, isWSL, ... }:
{
  config,
  pkgs,
  lib,
  ...
}:
let
  useGUI = !isWSL;

  cliPkgs = with pkgs; [
    bundler
    clamav
    clang
    claude-code
    cmake
    curl
    difftastic
    direnv
    eza
    gettext
    git
    gnupg
    fzf
    jq
    lazydocker
    lazygit
    lazysql
    libtool
    navi
    nil
    ninja
    nixpkgs-fmt
    pass
    peco
    pinentry-qt
    ripgrep
    rustup
    sheldon
    ssm-session-manager-plugin
    taplo
    tree
    tree-sitter
    unzip
    xlsx2csv
    yazi
  ];

  guiPkgs = with pkgs; [
    bitwarden-desktop
    discord
    ghostty
    gnome-boxes
    gnome-pomodoro
    google-chrome
    libreoffice
    obsidian
    slack
    xclip
    xdg-desktop-portal-gnome
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
  ];

  # starship
  starshipSettings = import ./starship/settings.nix;

  # ghostty
  ghosttySettings = import ./ghostty/settings.nix;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    stateVersion = "25.11";
    packages = cliPkgs ++ (lib.optionals (useGUI) guiPkgs);
    sessionVariables = {
      HOGE = "hoge";
    };
  };

  xdg = {
    configFile = {
      "zellij/config.kdl".text = builtins.readFile ./zellij/settings.kdl;
      "alacritty/themes/sonokai.toml".text = builtins.readFile ./alacritty/themes/sonokai.toml;
    };
  };

  programs = {
    zsh = {
      enable = true;
      initExtra = builtins.readFile ./zsh/extrarc;
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

    ghostty = {
      enable = true;
      settings = ghosttySettings;
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
      userName = "keito-osaki";
      userEmail = "o.keito317@gmail.com";
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
        };
      };
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
    enable = useGUI;
    settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          "Bluetooth-Battery-Meter@maniacx.github.com"
          "clipboard-indicator@tudmotu.com"
          "dash-to-dock@micxgx.gmail.com"
          "kimpanel@kde.org"
          "paperwm@paperwm.github.com"
          "pomodoro@arun.codito.in"
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "tailscale-status@maxgallup.github.com"
        ];
      };
    };
  };
}
