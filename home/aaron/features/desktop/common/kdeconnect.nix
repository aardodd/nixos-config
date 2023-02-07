{ pkgs, lib, ... }: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  home.persistence = {
    "/persist/home/aaron".directories = [
      ".config/kdeconnect"
    ];
  };
}
