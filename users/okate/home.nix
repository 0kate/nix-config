{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    awscli2
    clang
    cmake
    curl
    direnv
    eza
    gettext
    git
    gnupg
    google-cloud-sdk
    lazydocker
    lazygit
    ninja
    pass
    pinentry-tty
    python312
    python312Packages.pip
    ripgrep
    rustup
    sheldon
    tree-sitter
    unzip
    vim
    zellij
  ] ++ (lib.optionals (!isWSL) [
    bitwarden-desktop
    firefox
    google-chrome
    slack
    wezterm
    xclip
  ]);

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xdg.configFile = {
    "sheldon/plugins.toml".text = builtins.readFile ./sheldon.toml;
    "zellij/config.kdl".text = builtins.readFile ./zellij.kdl;
    "nvim/init.lua".text = builtins.readFile ./nvim/init.lua;
    "nvim/neovim.yml".text = builtins.readFile ./nvim/neovim.yml;
    "nvim/selene.toml".text = builtins.readFile ./nvim/selene.toml;
  };
  
  home.file.".config/nvim/lua" = {
    source = ./nvim/lua;
  };

  programs.zsh = {
    enable = true;
    initExtra = builtins.readFile ./zshrc;

    shellAliases = {
      lgd = "lazydocker";
      lgg = "lazygit";
      ls  = "eza --icons";
      zj  = "zellij";
    };
  };

  programs.git = {
    enable = true;
    userName = "keito-osaki";
    userEmail = "o.keito317@gmail.com";
  };

  programs.neovim = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./lazygit.json);
  };

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };
}
