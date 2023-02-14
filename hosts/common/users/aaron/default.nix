{ pkgs, config, lib, outputs, ... }:
let
  ifGroupsExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = true;
  users.users.aaron = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
    ] ++ ifGroupsExist [
      "network"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];
    initialPassword = "deadbread";
    packages = [ pkgs.home-manager ];
  };

  home-manager.users.aaron = import ../../../../home/aaron/${config.networking.hostName}.nix;
}
