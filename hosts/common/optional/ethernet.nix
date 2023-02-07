{ pkgs, ... }: {
  networking.networkmanager.enable = true;

  environment.persistence = {
    "/persist".directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/timestamps"
    ];
  };
}
