{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    awscli2
    bundler
    clamav
    clang
    cmake
    curl
    devbox
    direnv
    docker-compose-language-service
    dockerfile-language-server-nodejs
    eza
    gettext
    git
    gnupg
    google-cloud-sdk
    helix
    jdt-language-server
    jq
    lazydocker
    lazygit
    nil
    ninja
    nixpkgs-fmt
    nodejs_22
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
  ] ++ (lib.optionals (!isWSL) [
    alacritty
    android-studio
    bitwarden-desktop
    brave
    dbeaver-bin
    drawio
    firefox
    gnome-boxes
    google-chrome
    proton-pass
    slack
    tdrop
    wezterm
    xclip
    xdotool
    xorg.xprop
    xorg.xrandr
    xorg.xwininfo
    zoom-us

    inputs.ghostty.packages.${pkgs.system}.default
  ]);

  home.sessionVariables = {
    EDITOR = "hx";
  };

  xdg.configFile = {
    "zellij/config.kdl".text = builtins.readFile ./zellij.kdl;
    "alacritty/alacritty.toml".text = builtins.readFile ./alacritty.toml;
    "ghostty/config".text = builtins.readFile ./ghostty;
    "helix/config.toml".text = builtins.readFile ./helix/config.toml;
    "helix/languages.toml".text = builtins.readFile ./helix/languages.toml;
    "starship.toml".text = builtins.readFile ./starship.toml;
  };
  
  dconf = {
    enable = !isWSL;
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

  services.sxhkd.enable = true;

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zshrc;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      lgd = "lazydocker";
      lgg = "lazygit";
      ls  = "eza --icons";
      zj  = "zellij";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src  = pkgs.fetchFromGitHub {
          owner  = "romkatv";
          repo   = "powerlevel10k";
          rev    = "v1.20.0";
          sha256 = "ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
        };
      }
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
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

  programs.lazygit = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./lazygit.json);
  };
  
  programs.zellij = {
    enable = true;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
