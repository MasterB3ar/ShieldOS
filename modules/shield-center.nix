{ config, lib, pkgs, ... }:

let
  # One Python runtime for every ShieldOS native app.
  shieldPython = pkgs.python3.withPackages (pythonPackages: [
    pythonPackages.tkinter
  ]);

  appSource = ../apps/shield-center/shield_apps.py;

  mkShieldApp = name: mode: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [ shieldPython xdg-utils coreutils ];
    text = ''
      export SHIELDOS_APP="${mode}"
      exec ${shieldPython}/bin/python3 ${appSource} ${mode} "$@"
    '';
  };

  shieldCenter = mkShieldApp "shield-center" "center";
  shieldPrivacy = mkShieldApp "shield-privacy" "privacy";
  shieldStore = mkShieldApp "shield-store" "store";
  shieldUpdates = mkShieldApp "shield-updates" "updates";
  shieldVault = mkShieldApp "shield-vault" "vault";
  shieldWelcome = mkShieldApp "shield-welcome" "welcome";

  shieldBrowser = pkgs.writeShellApplication {
    name = "shield-browser";
    runtimeInputs = with pkgs; [ firefox ];
    text = ''
      exec firefox "$@"
    '';
  };

  mkDesktop = name: desktopName: comment: execPkg: icon: categories:
    pkgs.makeDesktopItem {
      inherit name desktopName comment icon categories;
      exec = "${execPkg}/bin/${name}";
      terminal = false;
    };

  desktopItems = [
    (mkDesktop "shield-center" "Shield Center" "Control hub for ShieldOS privacy, apps, updates and identity" shieldCenter "shieldos" [ "System" "Settings" "Security" ])
    (mkDesktop "shield-privacy" "Shield Privacy" "Privacy score, permissions, tracker blocking and Private Mode" shieldPrivacy "shieldos-privacy" [ "System" "Security" ])
    (mkDesktop "shield-store" "Shield Store" "Curated app support through Nix and Flathub" shieldStore "shieldos-store" [ "System" "Utility" ])
    (mkDesktop "shield-updates" "Shield Updates" "Safe updates and rollback guidance" shieldUpdates "shieldos-updates" [ "System" "Settings" ])
    (mkDesktop "shield-vault" "Shield Vault" "Private local protected folder" shieldVault "shieldos-vault" [ "Utility" "Security" ])
    (mkDesktop "shield-welcome" "Shield Welcome" "First-run setup and identity tools for ShieldOS" shieldWelcome "shieldos-welcome" [ "System" "Utility" ])
    (mkDesktop "shield-browser" "Shield Browser" "Firefox branded launcher for private browsing on ShieldOS" shieldBrowser "shieldos-browser" [ "Network" "WebBrowser" ])
  ];

in {
  environment.systemPackages = [
    shieldCenter
    shieldPrivacy
    shieldStore
    shieldUpdates
    shieldVault
    shieldWelcome
    shieldBrowser
  ] ++ desktopItems;

  environment.pathsToLink = [
    "/share/applications"
    "/share/icons"
  ];

  environment.shellAliases = {
    shield = "shield-center";
  };

  # Use absolute /nix/store paths here. This fixes the problem where only the center
  # could be found from some launchers while the other Shield apps did not open.
  environment.etc."xdg/autostart/shield-welcome.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Shield Welcome
    Exec=${shieldWelcome}/bin/shield-welcome
    Icon=shieldos-welcome
    X-KDE-autostart-after=panel
    Terminal=false
    Hidden=false
  '';

  environment.etc."skel/Desktop/Shield Center.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Shield Center
    Comment=Control hub for ShieldOS
    Exec=${shieldCenter}/bin/shield-center
    Icon=shieldos
    Terminal=false
    Categories=System;Settings;Security;
  '';
}
