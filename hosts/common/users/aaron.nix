{ pkgs, config, lib, outputs, ... }:
let
  inherit (builtins) filter hasAttr head map pathExists;

  username = "aaron";
  homePath = ../../../home/${username};
  homeConfigPaths = [ "${config.networking.hostName}.nix" "generic.nix" ];

  ifGroupsExist = groups: filter (group: hasAttr group config.users.groups) groups;
  userConfigExists = root: files: head (filter (p: pathExists p) (map (f: "${root}/${f}") files));
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
      "networkmanager"
    ] ++ ifGroupsExist [
      "network"
      "docker"
      "podman"
      "git"
      "libvirtd"
    ];
    initialPassword = "deadbread";
  };

  home-manager.users.${username} = import (userConfigExists homePath homeConfigPaths);
}
