{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/aaron.nix

    ../common/optional/gnome.nix
  ];

  networking = {
    hostName = "toast";
    useDHCP = false;
  };

  boot = {
    loader.grub.devices = [ "/dev/sda" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  programs = {
    adb.enable = true;
    dconf.enable = true;
  };

  services.dbus.packages = [ pkgs.gcr ];

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  security.polkit.enable = true;
  virtualisation.libvirtd = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [ virt-manager ];

  system.stateVersion = "22.11";
}