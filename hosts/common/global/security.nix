{ pkgs, ... }: {
  security.sudo = {
    enable = false;
    extraConfig = ''
      aaron ALL=(ALL) NOPASSWD:ALL
    '';
  };

  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };
}