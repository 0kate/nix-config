{ pkgs, inputs, ... }:
{
  programs.zsh.enable = true;

  users.users."okate" = {
    isNormalUser = true;
    home = "/home/okate";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
  };
}
