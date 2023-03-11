{ pkgs, ... }: {
  imports = [
    ../common/x11
  ];

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = {
      enable = true;
    };
  };

  programs = {
    bash.initExtra = ''
      if [[ -z $DISPLAY && [ "$(tty)" == "/dev/tty1" ]]; then
        exec startx &> /dev/null
      fi
    '';

    fish.loginShellInit = ''
      if test -z "$DISPLAY" -a (tty) = '/dev/tty1'
        exec startx &> /dev/null
      end
    '';

    zsh.initExtra = ''
      if [[ -z $DISPLAY && [ "$(tty)" == "/dev/tty1" ]]; then
        exec startx &> /dev/null
      fi
    '';
  };

  home.file = {
    ".xinitrc".text = ''
      exec i3
    '';
  };
}
