{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./nix-index.nix
    ./pfetch.nix
    ./ranger.nix
    ./ssh.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [
    bc # Calculator
    bottom # System viewer
    comma # Install and run programs by sticking a , before them
    distrobox # Integrate docker images into the environment
    exa # Better ls
    fd # Better find
    httpie # Better curl
    hledger # Finance tracking
    just # Task runner
    jq # JSON pretty printer and manipulator
    ncdu # TUI disk usage
    nixfmt # Nix formatter
    restic # Backups
    ripgrep # Better grep
  ];
}
