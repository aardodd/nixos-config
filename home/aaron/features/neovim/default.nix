{ config, pkgs, lib, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
