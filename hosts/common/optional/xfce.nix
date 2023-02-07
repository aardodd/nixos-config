{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.xfce.enable = true;
    };
  };

  networking.networkmanager.enable = true;
}
