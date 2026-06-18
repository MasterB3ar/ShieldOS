{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop-plasma.nix
    ../../modules/identity.nix
    ../../modules/privacy.nix
    ../../modules/app-support.nix
    ../../modules/gaming.nix
    ../../modules/developer.nix
    ../../modules/shield-center.nix
  ];

  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "shieldos";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.zfs.forceImportRoot = false;

  users.users.shield = {
    isNormalUser = true;
    description = "ShieldOS User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "podman" ];
    initialPassword = "shield";
  };

  security.sudo.wheelNeedsPassword = false;

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.vmware.guest.enable = true;
  virtualisation.virtualbox.guest.enable = true;

  environment.etc."shieldos-release".text = ''
    NAME=ShieldOS
    VERSION="0.3.1 Real UI Build"
    BASE="NixOS 26.05"
    PRIVACY_DEFAULT="normal-private"
    IDENTITY="shieldos-dark-aurora"
  '';
}
