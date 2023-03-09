{ pkgs, ... }: {
  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  home.persistence = {
    "/persist/home/aaron".directories = [
      ".config/broot"
    ];
  };
}
