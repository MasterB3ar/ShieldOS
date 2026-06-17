{ config, lib, pkgs, ... }:

let
  shieldCenter = pkgs.writeShellApplication {
    name = "shield-center";
    runtimeInputs = with pkgs; [ coreutils systemd iproute2 procps gnugrep gawk ];
    text = ''
      set +e

      firewall="unknown"
      if systemctl is-active --quiet firewall.service 2>/dev/null; then
        firewall="active"
      else
        firewall="inactive/unknown"
      fi

      private="OFF"
      if [ -f "$HOME/.local/state/shieldos/private-mode-on" ]; then
        private="ON"
      fi

      ip_summary="No network information available."
      if command -v ip >/dev/null 2>&1; then
        ip_summary=$(ip -brief address 2>/dev/null | head -8 || true)
      fi

      msg=$(cat <<EOFMSG
Shield Center
=============

Status
- Firewall: $firewall
- Private Mode: $private
- SSH: disabled by default
- App system: Nix + Flatpak + AppImage support
- Gaming: Steam/Proton, Heroic, Lutris, Prism, GameMode, MangoHud

Network
$ip_summary

Useful commands
- shield-private-mode on
- shield-private-mode off
- shield-private-mode status
- shield-privacy-report
- shield-install-vm --root /dev/vda2 --efi /dev/vda1

Installer safety
The installer does not accept whole disks. Use existing partitions only.
EOFMSG
)

      if command -v kdialog >/dev/null 2>&1; then
        kdialog --title "Shield Center" --msgbox "$msg" || true
      elif command -v zenity >/dev/null 2>&1; then
        zenity --info --title="Shield Center" --text="$msg" || true
      else
        printf '%s\n' "$msg"
      fi
    '';
  };

  shieldWelcome = pkgs.writeShellApplication {
    name = "shield-welcome";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      msg=$(cat <<EOFMSG
Welcome to ShieldOS 0.2 Daily Driver VM
======================================

This is a NixOS-based desktop OS prototype made for VM use.

Live login:
- Username: shield
- Password: shield

Use the app launcher to open:
- Discover app store
- Settings
- Files
- Shield Center
- Terminal

Safe VM install example:
  lsblk -f
  sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1

The installer refuses whole disks and does not run wipefs, parted, or mkfs.
EOFMSG
)

      if command -v kdialog >/dev/null 2>&1; then
        kdialog --title "Welcome to ShieldOS" --msgbox "$msg" || true
      elif command -v zenity >/dev/null 2>&1; then
        zenity --info --title="Welcome to ShieldOS" --text="$msg" || true
      else
        printf '%s\n' "$msg"
      fi
    '';
  };

in {
  environment.systemPackages = [
    shieldCenter
    shieldWelcome
  ];

  environment.etc."xdg/autostart/shield-welcome.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=ShieldOS Welcome
    Comment=Show ShieldOS first-run information
    Exec=shield-welcome
    Terminal=false
    X-GNOME-Autostart-enabled=true
  '';

  environment.etc."xdg/applications/shield-center.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Shield Center
    Comment=Privacy, system and install overview for ShieldOS
    Exec=shield-center
    Terminal=false
    Categories=System;Settings;
  '';
}
