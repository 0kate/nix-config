{ inputs, isWSL, ... }:
{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    asdf-vm
    clang
    cmake
    curl
    direnv
    eza
    gettext
    git
    lazydocker
    lazygit
    ninja
    ripgrep
    rustup
    sheldon
    tree-sitter
    unzip
    vim
    zellij
  ] ++ (lib.optionals (!isWSL) [
    firefox
    google-chrome
    wezterm
  ]);

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  home.file.".config/nvim/init.lua" = {
    text = builtins.readFile ./nvim/init.lua;
  };
  home.file.".config/nvim/neovim.yml" = {
    text = builtins.readFile ./nvim/neovim.yml;
  };
  home.file.".config/nvim/selene.toml" = {
    text = builtins.readFile ./nvim/selene.toml;
  };
  home.file.".config/nvim/lua" = {
    source = ./nvim/lua;
  };

  home.file.".tool-versions" = {
    text = builtins.readFile ./global-tool-versions;
  };

  xdg.configFile = {
    "sheldon/plugins.toml".text = builtins.readFile ./sheldon.toml;
    "zellij/config.kdl".text = builtins.readFile ./zellij.kdl;
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
