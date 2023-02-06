# nixos-config

My NixOS configuration for my machines.

## How do I...
### Set up a host

When building a new development environment from scratch, complete the following steps:

 - [ ] Download the NixOS minimal installer from the following link:
       https://nixos.org/download.html
 - [ ] Burn it.
 - [ ] Enter the minimal system.
 - [ ] Get root access:

```bash
sudo -i
sudo su
# etc...
```

 - [ ] Get access to Git:

```bash
nix-shell -p git
```

 - [ ] Clone and `cd` in to the repository:

```bash
git clone https://github.com/aardodd/nixos-config
exit # to get out of the initial nix-shell.
cd nixos-config
```

 - [ ] Download the development dependencies:

```bash
nix-shell
```

 - [ ] Use `lsblk` to find which disk you want to install to.
 - [ ] Find a partition layout. Look in `hosts/common/hardware/partitions` for premade layouts or make your own using `https://github.com/nix-community/disko/tree/master/example` as inspiration. In the guide we shall use the `hybrid-btrfs.nix` file.
 - [ ] Set up the partitions using the following command, substituting `/dev/sda` for your disk:

```bash
nix run github:nix-community/disko -- --mode zap_create_mount hosts/common/hardware/partitions/hybrid-btrfs.nix --arg disks '[ "/dev/sda" ]'
```

 - [ ] Clone or move the repository onto the formatted disk:

```bash
git clone https://github.com/aardodd/nixos-config /mnt/persist/nixos-config
cd /mnt/persist/nixos-config
```

#### Using an existing host

To reuse the configuration for an existing host, complete the following step(s), then continue on to [[#Finalising the installation]].

 - [ ] Remove the `hardware-configuration.nix` in `hosts/<hostname>`:

```bash
rm hosts/<hostname>/hardware-configuration.nix
```

 - [ ] Generate a new `hardware-configurattion.nix` without filesystem information:

```bash
nixos-generate-config --no-filesystems --root /mnt --dir hosts/<hostname>
```

 - [ ] Check disk layout information in the `configuration.nix` file matches what you expect:

```nix
disko.devices = (import ../common/hardware/partitions/hybrid-btrfs.nix {
  disks = [ "/dev/sda" ];
});
```

#### Registering a new host

To register a new host, complete the following step(s), then continue on to [[#Finalising the installation]].

 - [ ] Create a new `hostname` directory under the `hosts` folder:

```bash
mkdir -p ./hosts/<hostname>
```

 - [ ] Generate a new `configuration.nix` and `hardware-configurattion.nix` for the host:

```bash
nixos-generate-config --no-filesystems --root /mnt --dir hosts/<hostname>
```

 - [ ] Edit the `configuration.nix` file as necessary to support the new host.
 - [ ] IMPORTANT: Make sure disk layout information is added to the `configuration.nix` file:

```nix
imports = [
  ./hardware-configuration.nix
  inputs.disko.nixosModules.disko
];

disko.devices = (import ../common/hardware/partitions/hybrid-btrfs.nix {
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
```
 - [ ] Copy the template `default.nix` from an existing host to the new host configuration file:

```bash
cp hosts/<existing_hostname>/default.nix hosts/<hostname>
```

NOTE: This file contains the following content:

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

 - [ ] Make Nix aware of any new file(s) by adding them to the `git` index:

```bash
git add .
```

#### Finalising the installation

 - [ ] Install the configuration with the following command:

```bash
nixos-install --root /mnt --flake .#<hostname>
```

 - [ ] Reboot and login as the desired user(s) with their initial password(s).
 - [ ] Change the initial password(s).
 - [ ] Generate a new SSH key:

```bash
ssh-keygen -a 100 -t ed25519
```

 - [ ] Copy the public key to any services that need it (e.g., GitHub, GitLab, etc).
 - [ ] Commit any changes.
 - [ ] Push.
