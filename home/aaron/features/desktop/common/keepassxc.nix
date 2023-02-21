{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    keepassxc
  ];

  home.persistence = {
    "/persist/home/aaron".files = [
      ".cache/keepassxc/keepassxc.ini"
      ".config/keepassxc/keepassxc.ini"
      ".config/KeePassXCrc"
    ];
  };
}
