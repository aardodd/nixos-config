{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      cat = "bat";
      ls = "exa";

      n = "nix";
      nb = "nix build";
      nd = "nix develop -c $SHELL";
      nf = "nix flake";
      ngc = "nix-collect-garbage";
      dngc = "doas nix-collect-garbage";
      ngcd = "nix-collect-garbage -d";
      dngcd = "doas nix-collect-garbage -d";
      nrb = "nixos-rebuild boot --flake .";
      dnrb = "doas nixos-rebuild boot --flake .";
      nrs = "nixos-rebuild switch --flake .";
      dnrs = "doas nixos-rebuild switch --flake .";
      ns = "nix shell";
      nsn = "nix shell nixpkgs#";

      e = "emacsclient -t";
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
    functions = {
      fish_greeting = "";
      wh = "readlink -f (which $argv)";
    };
  };
}
