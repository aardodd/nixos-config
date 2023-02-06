{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
  ];

  home.packages = with pkgs; [
    keepassxc
  ];
}
