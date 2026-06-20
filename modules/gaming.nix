{ config, lib, pkgs, ... }:

let
  shieldSteam = pkgs.writeShellApplication {
    name = "shield-steam";
    runtimeInputs = with pkgs; [ coreutils gnugrep procps xdg-utils ];
    text = ''
      set -u
      LOG_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/shieldos"
      LOG_FILE="$LOG_DIR/steam.log"
      mkdir -p "$LOG_DIR"

      if ! command -v steam >/dev/null 2>&1; then
        MSG="Steam is not available in PATH. Rebuild ShieldOS with programs.steam.enable = true."
        if command -v kdialog >/dev/null 2>&1; then
          kdialog --error "$MSG"
        else
          echo "$MSG" >&2
        fi
        exit 127
      fi

      # These make Steam more reliable in VMs and with KDE/Wayland sessions.
      export STEAM_FORCE_DESKTOPUI=1
      export STEAM_RUNTIME=1
      export SDL_VIDEODRIVER="''${SDL_VIDEODRIVER:-x11}"

      echo "==== ShieldOS Steam launch: $(date -Is) ====" >> "$LOG_FILE"
      echo "Command: steam -no-cef-sandbox $*" >> "$LOG_FILE"
      nohup steam -no-cef-sandbox "$@" >> "$LOG_FILE" 2>&1 &
      disown || true

      if command -v kdialog >/dev/null 2>&1; then
        kdialog --passivepopup "Steam is starting. If it does not appear, open ~/.local/state/shieldos/steam.log" 6 || true
      else
        echo "Steam is starting. If it does not appear, check $LOG_FILE"
      fi
    '';
  };

  shieldSteamDesktop = pkgs.makeDesktopItem {
    name = "shield-steam";
    desktopName = "Steam";
    comment = "Launch Steam through the ShieldOS compatibility wrapper";
    exec = "${shieldSteam}/bin/shield-steam";
    icon = "steam";
    terminal = false;
    categories = [ "Game" "Network" ];
  };

in {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  # Steam/Proton needs 32-bit graphics libraries. Without this, Steam may do
  # nothing or exit quickly, especially inside VMs or with Proton dependencies.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI = "1";
  };

  environment.systemPackages = with pkgs; [
    shieldSteam
    shieldSteamDesktop
    mangohud
    goverlay
    protonup-qt
    lutris
    heroic
    prismlauncher
    gamescope
    vulkan-tools
    steam-run
  ];
}
