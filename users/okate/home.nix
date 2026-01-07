{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
let
  useGUI = !isWSL;

  cliPkgs = with pkgs; [
    bundler
    clamav
    clang
    claude-code
    cmake
    curl
    codex
    difftastic
    direnv
    docker-compose-language-service
    dockerfile-language-server-nodejs
    emacs
    emacs-lsp-booster
    eza
    gettext
    git
    gnupg
    fzf
    helix
    helix-gpt
    jq
    just
    lazydocker
    lazygit
    lazysql
    libtool
    navi
    nb
    nil
    ninja
    nixpkgs-fmt
    nodePackages_latest.vscode-json-languageserver
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
    yaml-language-server
    zellij
  ];

  guiPkgs = with pkgs; [
    alacritty
    android-studio
    bitwarden-desktop
    brave
    discord
    firefox
    ghostty
    gnome-boxes
    gnome-pomodoro
    google-chrome
    obsidian
    slack
    xclip
    xdg-desktop-portal-gnome
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    zed-editor
    zoom-us
  ];

  # alacritty
  alacrittySettings = import ./alacritty/settings.nix;

  # starship
  starshipSettings = import ./starship/settings.nix;

  # lazygit
  lazygitSettings = import ./lazygit/settings.nix;

  # zed-editor
  zedSettings = import ./zed-editor/settings.nix;
  zedKeymaps = import ./zed-editor/keymaps.nix;

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
    stateVersion = "25.05";
    packages = cliPkgs ++ (lib.optionals (useGUI) guiPkgs);
    # shell.enableZshIntegration = true;
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
        lgd = "lazydocker";
        lgg = "lazygit";
        lgs = "lazysql";
        ls  = "eza --icons";
        zj  = "zellij";
      };

      plugins = [
        {
          name = "zsh-autocomplete";
          src  = pkgs.fetchFromGitHub {
            owner  = "marlonrichert";
            repo   = "zsh-autocomplete";
            rev    = "24.09.04";
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

    alacritty = {
      enable = true;
      settings = alacrittySettings;
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

    lazygit = {
      enable = true;
      settings = lazygitSettings;
    };

    zellij = {
      enable = true;
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };

    zed-editor = {
      enable = true;
      userKeymaps = zedKeymaps;
      userSettings = zedSettings;
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
