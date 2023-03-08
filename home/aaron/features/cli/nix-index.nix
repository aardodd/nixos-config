{ pkgs, ... }:
let
  update-script = pkgs.writeShellApplication {
    name = "fetch-nix-index-database";
    runtimeInputs = with pkgs; [ wget coreutils ];
    text = ''
      filename="index-$(uname -m)-$(uname | tr '[:upper:]' '[:lower:]')"
      mkdir -p ~/.cache/nix-index
      cd ~/.cache/nix-index
      wget -N "https://github.com/Mic92/nix-index-database/releases/latest/download/$filename"
      ln -f "$filename" files
    '';
  };
in
{
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  systemd.user.services.nix-index-database-sync = {
    Unit = { Description = "fetch mic92/nix-index-database"; };
    Service = {
      Type = "oneshot";
      ExecStart = "${update-script}/bin/fetch-nix-index-database";
      Restart = "on-failure";
      RestartSec = "5m";
    };
  };

  systemd.user.timers.nix-index-database-sync = {
    Unit = { Description = "Automatic github:mic92/nix-index-database fetching"; };
    Timer = {
      OnBootSec = "5m";
      OnUnitActiveSec = "24h";
    };
    Install = { WantedBy = [ "timers.target" ]; };
  };

  home.persistence = {
    "/persist/home/aaron".directories = [
      ".cache/nix-index"
    ];
  };
}
