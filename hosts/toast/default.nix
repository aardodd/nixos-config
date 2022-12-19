{ pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/aaron.nix

    ../common/optional/plasma.nix
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
    vmware.guest.enable = true;
    libvirtd.enable = true;
  };
  environment.systemPackages = with pkgs; [ virt-manager ];

  system.stateVersion = "22.11";
}
