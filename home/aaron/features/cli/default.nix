{ pkgs, ... }: {
  imports = [
    ./fish.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    distrobox
    hledger
    jq
    just
    nixfmt
    restic
    ripgrep
  ];
}
