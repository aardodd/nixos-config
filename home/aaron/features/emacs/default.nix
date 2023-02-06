{ pkgs, ... }: {
  programs.emacs = {
    enable = true;
  };

  services.emacs = {
    enable = true;
    client.enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };
}