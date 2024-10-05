{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    clang
    cmake
    curl
    direnv
    eza
    gettext
    git
    lazydocker
    lazygit
    mise
    ninja
    ripgrep
    rustup
    sheldon
    tree-sitter
    unzip
    vim
    zellij
  ] ++ (lib.optionals (!isWSL) [
    bitwarden-desktop
    dracula-icon-theme
    firefox
    google-chrome
    numix-gtk-theme
    slack
    wezterm
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
    "mise/config.toml".text = builtins.readFile ./mise.toml;
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
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
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
