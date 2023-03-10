{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
    ./kdeconnect.nix
    ./keepassxc.nix
    ./kitty.nix
    ./syncthing.nix
  ];
}
