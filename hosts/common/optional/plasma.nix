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

  programs = {
    kdeconnect.enable = true;
    ssh.askPassword = pkgs.lib.mkForce "${pkgs.libsForQt5.ksshaskpass.out}/bin/ksshaskpass";
  };

  networking.networkmanager.enable = true;
}
