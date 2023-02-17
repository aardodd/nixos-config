# This file defines overlays
{ outputs, inputs }: {
  # This one brings our custom packages from the 'packages' directory
  additions = final: _prev: import ../packages { pkgs = final; };

  # Unstable nixpkgs
  unstable = final: prev: {
    unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
  };

  # Master nixpkgs
  master = final: prev: {
    master = inputs.nixpkgs-master.legacyPackages.${final.system};
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };
}
