{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
      };
      desktopManager.plasma5.enable = true;
    };
  };

  programs.kdeconnect = {
    enable = true;
  };

  networking.networkmanager.enable = true;
}
