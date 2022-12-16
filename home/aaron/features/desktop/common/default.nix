{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
    ./font.nix
  ];

  xdg.mimeApps.enable = true;
}
