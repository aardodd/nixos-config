{ pkgs, config, lib, outputs, ... }:
let
  username = "aaron";
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "network"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];
    initialPassword = "deadbread";
  };

  home-manager.users.${username} = import ../../../home/${username}/${config.networking.hostName}.nix;
}