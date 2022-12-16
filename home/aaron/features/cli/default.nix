{ pkgs, ... }: {
  home.packages = with pkgs; [
    distrobox
    jq
    nixfmt
    ripgrep
  ];
}
