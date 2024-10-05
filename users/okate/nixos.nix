{ pkgs, inputs, ... }:
{
  programs.zsh.enable = true;

  users.users."okate" = {
    isNormalUser = true;
    home = "/home/okate";
    hashedPassword = "$y$j9T$ubiv8LXGhk3bttXtvfCQ9/$QU9AuQnzCsTgkb43UOHULj0Al3sC5VRGgkZFs6K5w83";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
