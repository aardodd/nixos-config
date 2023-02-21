# nixos-config

My NixOS configuration for my machines.

## How do I...
### Set up a host

When building a new development environment from scratch, complete the following steps:

 - [ ] Download the NixOS minimal installer from the following link:
       https://nixos.org/download.html
 - [ ] Burn it.
 - [ ] Enter the minimal system.
 - [ ] Give yourself root access.
 - [ ] Get access to `git` using `nix-shell -p git`.
 - [ ] Clone the repository.
 - [ ] Download the development dependencies using `nix-shell`.
 - [ ] Find a partition layout. Look in `hosts/common/partitions` for premade layouts or make your own using `https://github.com/nix-community/disko/tree/master/example` as inspiration. In the guide we shall use the `hybrid-btrfs.nix` file.
 - [ ] Set up the partitions using the following command, substituting `/dev/sda` for your chosen storage device:

```bash
nix run github:nix-community/disko -- --mode zap_create_mount hosts/common/partitions/hybrid-btrfs.nix --arg disks '[ "/dev/sda" ]'
```

 - [ ] Move the checked-out repository to a folder within the `/persist` directory on the mounted storage. In this guide we assume `/mnt/persist/nixos-config`.

#### Using an existing host

 - [ ] Remove the `hardware-configuration.nix` file in `hosts/<hostname>`.
 - [ ] Generate a new `hardware-configuration.nix` without filesystem information:

```bash
nixos-generate-config --no-filesystems --root /mnt --dir hosts/<hostname>
```

 - [ ] Check disk layout file in `configuration.nix` file matches what you expect:

```nix
disko.devices = (import ../common/partitions/hybrid-btrfs.nix {
  disks = [ "/dev/sda" ];
});
```

 - [ ] Continue to [[#Finalising the installation]].

#### Registering a new host

 - [ ] Create a new `hostname` directory under the `hosts` folder.
 - [ ] Generate a new `configuration.nix` and `hardware-configurattion.nix`:

```bash
nixos-generate-config --no-filesystems --root /mnt --dir hosts/<hostname>
```

 - [ ] Edit the `configuration.nix` file as necessary to support the new host.
 - [ ] IMPORTANT: Make sure the disk layout information is added to the `configuration.nix` file:

```nix
{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
  ];

  disko.devices = (import ../common/partitions/hybrid-btrfs.nix {
    disks = [ "/dev/sda" ];
  });

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader.grub = {
      devices = [ "/dev/sda" ];
      enable = true;
      version = 2;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}
```

 - [ ] Create a `default.nix` file for the new host with the following content:

```nix
{
  imports = [
    ./configuration.nix
  ];
}
```

 - [ ] Register the new host in the `flake.nix` file.

```nix
nixosConfigurations = rec {
  <hostname> = nixpkgs.lib.nixosSystem {
	  specialArgs = { inherit inputs outputs; };
	  modules = [ ./hosts/<hostname> ];
  };
};
```

 - [ ] Make Nix aware of any new file(s) by adding them to the `git` index.
 - [ ] Continue to [[#Finalising the installation]].

#### Finalising the installation

 - [ ] Install the configuration by executing the following command:

```bash
nixos-install --root /mnt --flake .#<hostname>
```

 - [ ] Reboot into the installed system.
 - [ ] Login with your user account.
 - [ ] Change passwords.
 - [ ] Mark your user as owning `/persist` and `/persist/nixos-config` (including all subdirectories):

```bash
doas chown -h <username> /persist
doas chown -hR <username> /persist/nixos-config
```

 - [ ] Generate your home configuration by executing the following command:

```bash
doas nixos-rebuild boot --flake .#<hostname>
```

 - [ ] Reboot so that the home-manager configuration for your user can take effect.
 - [ ] Generate a new SSH key by executing the following command:

```bash
ssh-keygen -a 100 -t ed25519
```

 - [ ] Copy the public key to any services that need it (e.g., GitHub, GitLab, etc).
 - [ ] Commit and push any changes.
