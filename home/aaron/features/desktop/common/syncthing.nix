{ pkgs, ... }: {
  services.syncthing = {
    enable = true;
  };

  home.persistence = {
    "/persist/home/aaron" = {
      directories = [
        ".config/syncthing"
        "Sync"
      ];
    };
  };
}