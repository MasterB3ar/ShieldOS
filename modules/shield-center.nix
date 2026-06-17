{ config, lib, pkgs, ... }:

let
  shieldCenter = pkgs.writeShellApplication {
    name = "shield-center";
    runtimeInputs = with pkgs; [ python3Full coreutils systemd iproute2 procps ];
    text = ''
      exec ${pkgs.python3Full}/bin/python3 ${../apps/shield-center/main.py} "$@"
    '';
  };

  shieldWelcome = pkgs.writeShellApplication {
    name = "shield-welcome";
    runtimeInputs = with pkgs; [ python3Full ];
    text = ''
      exec ${pkgs.python3Full}/bin/python3 ${../apps/shield-center/welcome.py} "$@"
    '';
  };

in {
  environment.systemPackages = [ shieldCenter shieldWelcome ];

  environment.etc."xdg/autostart/shield-welcome.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=ShieldOS Welcome
    Exec=shield-welcome
    X-KDE-autostart-after=panel
  '';

  environment.etc."skel/Desktop/Shield Center.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Shield Center
    Comment=Privacy, security, gaming and developer controls
    Exec=shield-center
    Icon=preferences-system-privacy
    Terminal=false
    Categories=System;Security;
  '';

  environment.etc."xdg/applications/shield-center.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Shield Center
    Comment=Privacy, security, gaming and developer controls
    Exec=shield-center
    Icon=preferences-system-privacy
    Terminal=false
    Categories=System;Security;
  '';
}
