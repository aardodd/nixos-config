{ pkgs, ... }: {
  imports = [
    ../common/x11
  ];

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  home.file = {
    ".xinitrc".text = ''
      exec xmonad
    '';
  };
}
