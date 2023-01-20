{ pkgs, ... }: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };
}