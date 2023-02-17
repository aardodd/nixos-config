{ pkgs, ... }: {
  imports = [
    ./fish.nix
    ./git.nix
    ./ssh.nix
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
