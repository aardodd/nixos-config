{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    keepassxc
  ];
}
