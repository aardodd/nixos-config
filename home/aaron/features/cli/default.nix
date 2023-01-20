{ pkgs, ... }: {
  imports = [
    ./fish.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    distrobox
    emacs
    hledger
    jq
    just
    nixfmt
    restic
    ripgrep
  ];
}
