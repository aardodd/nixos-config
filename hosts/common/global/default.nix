{ pkgs, lib, inputs, outputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    inputs.home-manager.nixosModules.home-manager
    ./fish.nix
    ./locale.nix
    ./nix.nix
    ./openssh.nix
    ./security.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
    };
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    systemPackages = with pkgs; [ git ];
  };

  services.dbus.enable = true;

  programs.fuse.userAllowOther = true;
  hardware.enableAllFirmware = true;
}
