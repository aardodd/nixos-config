{ outputs, lib, ... }:
let
  hostnames = builtins.attrNames outputs.nixosConfigurations;
in
{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      net = {
        host = builtins.concatStringMap " " hostnames;
        forwardAgent = true;
      };
    };
  };

  home.persistence = {
    "/persist/home/aaron".directories = [ ".ssh" ];
  };
}
