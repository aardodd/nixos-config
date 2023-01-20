{ pkgs, lib, outputs, ... }:
{
  imports = [
    ./firefox.nix
    ./font.nix
  ];

  xdg.mimeApps.enable = true;

  home.packages = with pkgs; [
    gimp
    kdenlive
    keepassxc
    obs-studio
    thunderbird
  ];
}
