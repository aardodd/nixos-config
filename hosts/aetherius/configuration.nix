{ pkgs, inputs, ... }:
let
  hostName = "aetherius";
  hostId = "deadbeef";
  disks = [ "/dev/nvme0n1" ];
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ../common/optional/btrfs-optin-persistence.nix

    ../common/global
    ../common/users/aaron

    ../common/optional/plasma.nix
    ../common/optional/ethernet.nix
    ../common/optional/zram-swap.nix
  ];

  # TODO: Come back and see if this can be tidied up.
  disko.devices = (import ../common/partitions/encrypted-hybrid-btrfs.nix {
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

  system.stateVersion = "22.11";
}
