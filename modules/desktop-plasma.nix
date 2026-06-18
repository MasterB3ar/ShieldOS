{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Familiar Windows-like desktop base: taskbar, launcher, tray, file manager and app store.
  programs.kdeconnect.enable = true;
  programs.firefox.enable = true;

  fonts.packages = with pkgs; [
    inter
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

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
    kdePackages.discover
    kdePackages.systemsettings
    kdePackages.plasma-workspace
    kdePackages.qttools
    kdePackages.flatpak-kcm
    libreoffice-qt6-fresh
    vlc
  ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ kdePackages.xdg-desktop-portal-kde ];
  };
}
