{ config, lib, pkgs, ... }:

let
  optionalPkg = name: lib.optional (builtins.hasAttr name pkgs) (builtins.getAttr name pkgs);
in {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Keep the desktop familiar and low-friction.
  programs.kdeconnect.enable = true;
  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  environment.etc."shieldos/wallpapers/shieldos-wallpaper.svg".source = ../assets/shieldos-wallpaper.svg;

  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    kdePackages.dolphin
    kdePackages.konsole
    kdePackages.kate
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.okular
    kdePackages.spectacle
    kdePackages.filelight
    kdePackages.plasma-browser-integration
    kdePackages.kcalc
    libreoffice-qt6-fresh
    vlc
  ] ++ optionalPkg "mission-center";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
  };
}
