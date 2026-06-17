{ config, lib, pkgs, ... }:

{
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dk";
  services.xserver.xkb.layout = "dk";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  boot = {
    kernelParams = [ "quiet" "splash" ];
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = false;
    graphics.enable = true;
  };

  networking.networkmanager.enable = true;
  services.fwupd.enable = true;
  services.printing.enable = true;
  services.tailscale.enable = true;

  programs.zsh.enable = true;
  programs.nano.enable = true;
  programs.command-not-found.enable = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    unzip
    p7zip
    pciutils
    usbutils
    lshw
    btop
    fastfetch
    htop
    jq
    ripgrep
    fd
    tree
    file
    killall
    wl-clipboard
    xdg-utils
    glib
  ];
}
