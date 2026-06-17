{ config, lib, pkgs, ... }:

let
  optionalPkg = name: lib.optional (builtins.hasAttr name pkgs) (builtins.getAttr name pkgs);

  privacyReport = pkgs.writeShellApplication {
    name = "shield-privacy-report";
    runtimeInputs = with pkgs; [ coreutils systemd iproute2 procps gnugrep gawk ];
    text = ''
      echo "ShieldOS Privacy Report"
      echo "========================"
      echo
      echo "Firewall:"
      systemctl is-active --quiet firewall.service && echo "  active" || echo "  unknown/inactive"
      echo
      echo "Network interfaces:"
      ip -brief address || true
      echo
      echo "Listening services:"
      ss -tulpn 2>/dev/null || true
      echo
      echo "Background user processes:"
      ps -eo user,pid,comm,%mem,%cpu --sort=-%cpu | head -25
      echo
      echo "Tip: open Shield Center for a simpler view."
    '';
  };

  privateMode = pkgs.writeShellApplication {
    name = "shield-private-mode";
    runtimeInputs = with pkgs; [ coreutils libnotify procps iproute2 networkmanager ];
    text = ''
      set -euo pipefail
      case "''${1:-status}" in
        on)
          mkdir -p "$HOME/.local/state/shieldos"
          date > "$HOME/.local/state/shieldos/private-mode-on"
          notify-send "ShieldOS" "Private Mode enabled: background visibility reduced." || true
          echo "Private Mode enabled."
          echo "Recommended next steps: close apps you do not trust, use a VPN, and use Flatpak permissions."
          ;;
        off)
          rm -f "$HOME/.local/state/shieldos/private-mode-on"
          notify-send "ShieldOS" "Private Mode disabled." || true
          echo "Private Mode disabled."
          ;;
        status)
          if [ -f "$HOME/.local/state/shieldos/private-mode-on" ]; then
            echo "Private Mode: ON"
          else
            echo "Private Mode: OFF"
          fi
          ;;
        *)
          echo "Usage: shield-private-mode [on|off|status]" >&2
          exit 2
          ;;
      esac
    '';
  };

in {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];
    logRefusedConnections = false;
  };

  security.apparmor.enable = true;
  security.auditd.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.openssh.enable = false;
  services.flatpak.enable = true;

  # Privacy-oriented NetworkManager defaults.
  environment.etc."NetworkManager/conf.d/00-shieldos-privacy.conf".text = ''
    [connection]
    connection.mdns=0
    connection.llmnr=0

    [device]
    wifi.scan-rand-mac-address=yes
  '';

  services.resolved = {
    enable = true;
    settings = {
      Resolve = {
        DNSOverTLS = "yes";
        DNSSEC = "allow-downgrade";
        LLMNR = "no";
        MulticastDNS = "no";
      };
    };
  };

  services.journald.extraConfig = ''
    SystemMaxUse=200M
    MaxRetentionSec=7day
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    privacyReport
    privateMode
    keepassxc
    flatpak
    bubblewrap
    apparmor-bin-utils
  ]
  ++ optionalPkg "veracrypt"
  ++ optionalPkg "tor-browser"
  ++ optionalPkg "tor-browser-bundle-bin"
  ++ optionalPkg "onionshare-gui";
}
