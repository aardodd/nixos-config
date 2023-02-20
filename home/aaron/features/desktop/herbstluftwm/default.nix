{ config, inputs, lib, pkgs, ... }: {
  imports = [
    ../common/x11-wm
  ];

  xsession.windowManager.herbstluftwm = {
    enable = true;

    keybinds = {
      Mod4-Shift-q = "quit";
      Mod4-Shift-r = "reload";
      Mod4-Shift-c = "close";

      Mod4-Return = "spawn alacritty";

      Mod4-Left = "focus left";
      Mod4-Right = "focus right";
      Mod4-Up = "focus up";
      Mod4-Down = "focus down";

      Mod4-Shift-Left = "shift left";
      Mod4-Shift-Right = "shift right";
      Mod4-Shift-Up = "shift up";
      Mod4-Shift-Down = "shift down";

      Mod4-u = "split bottom 0.5";
      Mod4-o = "split right 0.5";

      Mod4-Control-Space = "split explode";

      Mod4-Control-Left = "resize left +0.05";
      Mod4-Control-Right = "resize right +0.05";
      Mod4-Control-Up = "resize up +0.05";
      Mod4-Control-Down = "resize down +0.05";

      Mod4-period = "use_index +1 --skip-visible";
      Mod4-comma = "use_index -1 --skip-visible";

      Mod4-r = "remove";
      Mod4-space = "cycle_layout 1";
      Mod4-s = "floating toggle";
      Mod4-f = "fullscreen toggle";
      Mod4-p = "pseudotile toggle";

      Mod4-c = "cycle";
      Mod4-Tab = "cycle_all +1";
      Mod4-Shift-Tab = "cycle_all -1";
    };
  };
}