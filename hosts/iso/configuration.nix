{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../../modules/base.nix
    ../../modules/desktop-plasma.nix
    ../../modules/privacy.nix
    ../../modules/developer.nix
    ../../modules/shield-center.nix
  ];

  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "shieldos";

  isoImage.isoName = "ShieldOS-VM-Developer-Preview-x86_64.iso";
  isoImage.volumeID = "SHIELDOS";
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
  isoImage.appendToMenuLabel = " ShieldOS VM Developer Preview";

  # Demo/live user. Change/remove this before publishing a public ISO.
  users.users.shield = {
    isNormalUser = true;
    description = "ShieldOS User";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "podman" ];
    initialPassword = "shield";
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "shield";

  # Helpful on the live ISO.
  services.getty.autologinUser = "shield";
  security.sudo.wheelNeedsPassword = false;

  # Safer VM behaviour.
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.vmware.guest.enable = true;
  virtualisation.virtualbox.guest.enable = true;

  environment.etc."shieldos-release".text = ''
    NAME=ShieldOS
    VERSION="VM Developer Preview 0.1"
    BASE="NixOS 26.05"
    PRIVACY_DEFAULT="strict-but-usable"
  '';
}
