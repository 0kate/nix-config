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
    firefox
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
    wezterm
  ]);

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
  home.file.".config/nvim" = {
    source = ./nvim;
  };

  home.file.".tool-versions" = {
    text = builtins.readFile ./global-tool-versions;
  };

  xdg.configFile = {
    "sheldon/plugins.toml".text = builtins.readFile ./sheldon.toml;
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
    userName = "0kate";
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
