#           ▜███▙       ▜███▙  ▟███▛
#            ▜███▙       ▜███▙▟███▛
#             ▜███▙       ▜██████▛
#      ▟█████████████████▙ ▜████▛     ▟▙
#     ▟███████████████████▙ ▜███▙    ▟██▙
#            ▄▄▄▄▖           ▜███▙  ▟███▛
#           ▟███▛             ▜██▛ ▟███▛
#          ▟███▛               ▜▛ ▟███▛
# ▟███████████▛                  ▟██████████▙
# ▜██████████▛                  ▟███████████▛
#       ▟███▛ ▟▙               ▟███▛
#      ▟███▛ ▟██▙             ▟███▛
#     ▟███▛  ▜███▙           ▝▀▀▀▀
#     ▜██▛    ▜███▙ ▜██████████████████▛
#      ▜▛     ▟████▙ ▜████████████████▛
#            ▟██████▙       ▜███▙
#           ▟███▛▜███▙       ▜███▙
#          ▟███▛  ▜███▙       ▜███▙
#          ▝▀▀▀    ▀▀▀▀▘       ▀▀▀▘
#
#

{
  description = "My NixOS Configuration";

  inputs = {
    # Pick a channel from https://status.nixos.org/
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    # Interfacing with Hardware.
    impermanence.url = "github:nix-community/impermanence";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # HomeManager as a dotfiles replacement.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fix command-not-found
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Software and Tweaks
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management.
    sops-nix.url = "github:mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;

      forEachSystem = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      templates = import ./templates;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachPkgs (pkgs: import ./packages { inherit pkgs; });
      devShells = forEachPkgs (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachPkgs (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = rec {
        aetherius = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/aetherius ];
        };
        vbox = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/vbox ];
        };
      };

      homeConfigurations = {
        # Laptop configuration
        "aaron@aetherius" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/aaron/aetherius.nix ];
        };

        # Virtual machine configuration
        "aaron@vbox" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/aaron/vbox.nix ];
        };

        # Minimum configuration
        "aaron@generic" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/aaron/generic.nix ];
        };
      };

      apps = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mkApp = name: script: {
            type = "app";
            program = builtins.toString (pkgs.writeShellScript "${name}.sh" script);
          };
        in
        {
          fmt = mkApp "fmt" ''
            PATH=${with pkgs; lib.makeBinPath [ nix git ]}
            ${pkgs.lib.fileContents ./scripts/fmt.sh}
          '';
        }
      );
    };
}
