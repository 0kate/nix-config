{ ... }:
{
  imports = [
    ../shared.nix
  ];

  wsl = {
    enable = true;
  };

  system.stateVersion = "24.11";
}
