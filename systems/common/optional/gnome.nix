{ pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-terminal
    gnome3.gnome-tweaks
    gnomeExtensions.blur-my-shell
  ];

  environment.gnome.excludePackages = with pkgs; [
    gnome.epiphany
    gnome.geary
    gnome.gnome-music
    gnome.gnome-online-miners
    gnome.totem
  ];

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
}
