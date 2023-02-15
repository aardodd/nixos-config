{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      windowManager.bspwm.enable = true;
    };
  };

  networking.networkmanager.enable = true;
}