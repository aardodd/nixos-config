# nixos-config

My NixOS configuration for my machines.

## How do I...
### Set up a new host

 - [ ] Boot the NixOS standard installer as a base.
 - [ ] Set up the host by following `https://nixos.org/manual/nixos/stable/` or the graphical installer.
 
This will generate a suitable `configuration.nix` and `hardware-configuration.nix` in the `/etc/nixos` directory to use as a starting point.

 - [ ] Make edits to the generated files as necessary.
 - [ ] Include the following to enable flakes:

```nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

 - [ ] Access git and flakes using:

```bash
nix-shell -p nixFlakes git
```

 - [ ] Clone this repository:

```bash
git clone git@github.com:aardodd/nixos-config

cd nixos-config
```

 - [ ] Move the generated files:

```bash
cp /mnt/etc/nixos/configuration.nix ./hosts/<hostname>/configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/<hostname>/hardware-configuration.nix
```

 - [ ] Add an entry in `flake.nix` for the new host:


```nix
    nixosConfigurations.<hostname> = nixpkgs.lib.nixosSystem {
        inherit specialArgs system;
        modules = [
            ./shared
            ./hosts/<hostname>/configuration.nix
            "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
            sops-nix.nixosModules.sops
        ];
    };
```

 - [ ] Add the newly edited files to the git index:

```bash
git add .
```

 - [ ] Build the new system configuration from the `nixos-config` directory:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

 - [ ] Reboot and log in.
 - [ ] Generate an ed25519 SSH key:

```bash
ssh-keygen -a 100 -t ed25519
```

 - [ ] Add the public key to GitHub and anywhere else necessary.
 - [ ] Commit and push the changes.

```bash
git commit -m "Add host <hostname>"
git push
```
