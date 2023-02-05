{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
  ];

  xdg.mimeApps.enable = true;

  home.packages = with pkgs; [
    keepassxc
  ];
}
