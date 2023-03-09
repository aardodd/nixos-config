{ outputs, lib, config, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
    };
    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';
  };

  # Start ssh-agent as a systemd user service
  programs.ssh.startAgent = true;

  # Passwordless sudo when SSH'ing with keys
  security.pam.enableSSHAgentAuth = true;

  # Keep the systems' host keys.
  environment.persistence."/persist" = {
    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
    ];
  };
}
