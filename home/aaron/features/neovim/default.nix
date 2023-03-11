{ config, pkgs, lib, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };

  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = ./lua;
    };
  };
}
