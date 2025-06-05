{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
let
  useGUI = !isWSL;

  cliPkgs = with pkgs; [
    awscli2
    bundler
    clamav
    clang
    cmake
    curl
    direnv
    docker-compose-language-service
    dockerfile-language-server-nodejs
    eza
    gettext
    git
    gnupg
    google-cloud-sdk
    helix
    helix-gpt
    jq
    just
    lazydocker
    lazygit
    lazysql
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
    tree-sitter
    unzip
    vim
    yaml-language-server
    zellij
  ];

  guiPkgs = with pkgs; [
    alacritty
    android-studio
    bitwarden-desktop
    brave
    firefox
    gnome-boxes
    google-chrome
    slack
    xclip
    xdg-desktop-portal-gnome
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    zoom-us
  ];

  # helix
  helixSettings = import ./helix/settings.nix;
  helixLanguages = import ./helix/languages.nix;

  # alacritty
  alacrittySettings = import ./alacritty/settings.nix;

  # starship
  starshipSettings = import ./starship/settings.nix;

  # lazygit
  lazygitSettings = import ./lazygit/settings.nix;
in
{
  home = {
    stateVersion = "25.05";
    packages = cliPkgs ++ (lib.optionals (useGUI) guiPkgs);
    shell.enableZshIntegration = true;
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
      initContent = builtins.readFile ./zsh/extrarc;
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

    helix = {
      enable = true;
      defaultEditor = true;
      settings = helixSettings;
      languages = helixLanguages;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
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

    lazygit = {
      enable = true;
      settings = lazygitSettings;
    };
  
    zellij = {
      enable = true;
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
          "system-monitor@gnome-shell-extensions.gcampax.github.com"
          "tailscale-status@maxgallup.github.com"
        ];
      };
    };
  };
}
