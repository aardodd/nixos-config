{ config, inputs, lib, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./rofi.nix
  ];
}