{ config, lib, pkgs, ... }:

let
  flatpakSetup = pkgs.writeShellApplication {
    name = "shield-setup-flathub";
    runtimeInputs = with pkgs; [ flatpak coreutils ];
    text = ''
      set -euo pipefail
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      echo "Flathub is enabled. Open Discover to install apps."
    '';
  };

  flatpakAppHelper = pkgs.writeShellApplication {
    name = "shield-install-common-apps";
    runtimeInputs = with pkgs; [ flatpak coreutils ];
    text = ''
      set -euo pipefail
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

      echo "Installing common daily-driver apps from Flathub..."
      flatpak install -y flathub \
        com.discordapp.Discord \
        com.spotify.Client \
        com.obsproject.Studio \
        com.usebottles.bottles \
        org.onlyoffice.desktopeditors \
        org.gimp.GIMP \
        org.kde.kdenlive \
        org.blender.Blender \
        org.videolan.VLC || true

      echo
      echo "Done. Some apps may be skipped if Flathub changes IDs or the network is unavailable."
    '';
  };

in {
  services.flatpak.enable = true;

  # Flathub is added after networking is available. This gives Discover a normal app-store source.
  systemd.services.shieldos-flathub = {
    description = "Enable Flathub for ShieldOS app support";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
    '';
  };


  environment.systemPackages = with pkgs; [
    flatpak
    flatpakSetup
    flatpakAppHelper
    appimage-run
    wineWow64Packages.stable
    winetricks
  ];
}
