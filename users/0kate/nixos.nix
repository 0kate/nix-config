{ pkgs, inputs, ... }:
{
  programs.zsh.enable = true;

  users.users."0kate" = {
    isNormalUser = true;
    home = "/home/0kate";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
  };
}
