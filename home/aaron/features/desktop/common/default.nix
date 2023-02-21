{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
    ./kdeconnect.nix
    ./keepassxc.nix
    ./syncthing.nix
  ];
}
