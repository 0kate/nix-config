{ inputs, ... }:
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
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
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
