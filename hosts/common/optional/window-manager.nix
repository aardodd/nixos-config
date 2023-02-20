{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      windowManager.herbstluftwm.enable = true;
    };
  };
}
