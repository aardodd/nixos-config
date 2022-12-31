# nixos-config

My NixOS configuration for my machines.

## How do I...
### Set up a host

When building a new development environment from scratch, complete the following steps:

 - [ ] Download the NixOS graphical installer from the following link:
       https://nixos.org/download.html
 - [ ] Download a hypervisor such as VirtualBox or VMWare.
 - [ ] Create a new virtual machine using the NixOS installer as installation media.
 - [ ] Start the virtual machine.
 - [ ] Follow the NixOS graphical installer instructions to get setup with a basic installation.
 - [ ] Reboot and log in to the virtual machine.
 - [ ] Gain an elevated shell using `sudo su` or similar.
 - [ ] Create a bootstrapping shell with the following commands:

```bash
nix-shell -p git nixFlakes
```

 - [ ] Clone and `cd` in to the `nixos-config` repository:

```bash
git clone https://github.com/aardodd/nixos-config ~/nixos-config
cd ~/nixos-config
```

#### Using an existing host

To reuse the configuration for an existing host, complete the following step(s), then continue on to [[#Finalising the installation]].

 - [ ] Replace the `hardware-configuration.nix` in `hosts/<hostname>` with the one located in `/etc/nixos`

```bash
rm ./hosts/<hostname>/hardware-configuration.nix
cp /etc/nixos/hardware-configuration.nix ./hosts/<hostname>/hardware-configuration.nix
```

#### Registering a new host

To register a new host, complete the following step(s), then continue on to [[#Finalising the installation]].

 - [ ] Create a new `hostname` directory under the `hosts` folder.

```bash
mkdir -p ./hosts/<hostname>
```

 - [ ] Copy the supplied `hardware-configuration.nix` file from the base system to the new hosts' configuration.

```bash
cp /etc/nixos/hardware-configuration.nix ./hosts/<hostname>
```

 - [ ] Copy the template `default.nix` from an existing host to the new host configuration.

```bash
cp hosts/<existing_hostname>/default.nix hosts/<hostname>
```

 - [ ] Edit the `default.nix` file as necessary to support the new host.
 - [ ] Register the new host in the `flake.nix` file.

```nix
nixosConfigurations = rec {
  # ... omitted other host definitions for brevity
  <hostname> = nixpkgs.lib.nixosSystem {
	specialArgs = { inherit inputs outputs; };
	modules = [ ./hosts/<hostname> ];
  };
```

#### Finalising the installation

 - [ ] Make Nix aware of the new file(s) by adding them to the `git` index:

```bash
git add .
```

 - [ ] Build the configuration with the following command:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

 - [ ] Reboot and login as the desired user(s) with their initial password(s).
 - [ ] Change the initial password(s).
 - [ ] Generate a new SSH key.

```bash
ssh-keygen -a 100 -t ed25519
```

 - [ ] Copy the public key to any services that need it (e.g., GitHub, GitLab, etc).
 - [ ] Commit any changes.
 - [ ] Push.
