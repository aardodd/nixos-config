{ pkgs, inputs, ... }:
let
  hostName = "vbox";
  hostId = "deadbeef";
  disks = [ "/dev/sda" ];
in {
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ../common/optional/btrfs-optin-persistence.nix

    ../common/global
    ../common/users/aaron.nix

    ../common/optional/plasma.nix
  ];

  # TODO: Come back and see if this can be tidied up.
  disko.devices = (import ../common/hardware/partitions/encrypted-hybrid-btrfs.nix {
    inherit disks;
  });

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader.grub = {
      devices = [ (builtins.elemAt disks 0) ];
      enable = true;
      version = 2;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  networking = {
    inherit hostName hostId;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    # Disable the firewall since we're in a VM and we want to make it
    # easy to visit stuff in here. We only use NAT networking anyways.
    firewall.enable = false;
  };

  services.dbus.packages = [ pkgs.gcr ];

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.polkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };

  environment.systemPackages = with pkgs; [ virt-manager ];

  system.stateVersion = "22.11";
}