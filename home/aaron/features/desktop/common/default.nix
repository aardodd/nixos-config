{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
    ./kdeconnect.nix
  ];

  home.packages = with pkgs; [
    keepassxc
  ];
}
