{ config, lib, pkgs, ... }:

let
  installedConfig = pkgs.writeText "shieldos-installed-configuration.nix" ''
    { config, lib, pkgs, ... }:

    {
      imports = [ ./hardware-configuration.nix ];

      system.stateVersion = "26.05";
      nixpkgs.config.allowUnfree = true;

      networking.hostName = "shieldos";
      networking.networkmanager.enable = true;
      time.timeZone = "Europe/Copenhagen";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "dk";
      services.xserver.xkb.layout = "dk";

      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.zfs.forceImportRoot = false;
      boot.kernelParams = [ "quiet" "splash" ];
      boot.plymouth.enable = true;

      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;
      hardware.graphics.enable = true;
      hardware.steam-hardware.enable = true;

      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;
      services.flatpak.enable = true;
      services.printing.enable = true;
      services.fwupd.enable = true;
      services.openssh.enable = false;
      services.tailscale.enable = true;
      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNSOverTLS = "yes";
          DNSSEC = "allow-downgrade";
          LLMNR = "no";
          MulticastDNS = "no";
        };
      };

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
      security.sudo.wheelNeedsPassword = false;

      users.users.shield = {
        isNormalUser = true;
        description = "ShieldOS User";
        extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "podman" ];
        initialPassword = "shield";
      };

      programs.firefox.enable = true;
      programs.kdeconnect.enable = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = false;
        dedicatedServer.openFirewall = false;
        localNetworkGameTransfers.openFirewall = false;
      };
      programs.gamemode.enable = true;
      programs.zsh.enable = true;
      programs.nano.enable = true;
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
      virtualisation.vmware.guest.enable = true;
      virtualisation.virtualbox.guest.enable = true;

      fonts.packages = with pkgs; [
        inter
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };

      environment.etc."NetworkManager/conf.d/00-shieldos-privacy.conf".text = ''''
        [connection]
        connection.mdns=0
        connection.llmnr=0

        [device]
        wifi.scan-rand-mac-address=yes
      '''';

      systemd.services.shieldos-flathub = {
        description = "Enable Flathub for ShieldOS app support";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''''
          ''${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true
        '''';
      };

      services.journald.extraConfig = ''''
        SystemMaxUse=200M
        MaxRetentionSec=7day
      '''';

      environment.systemPackages = with pkgs; [
        # Daily desktop
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
        kdePackages.flatpak-kcm
        libreoffice-qt6-fresh
        vlc

        # App compatibility
        flatpak
        appimage-run
        wineWowPackages.stable
        winetricks

        # Privacy and security
        keepassxc
        bubblewrap
        apparmor-bin-utils

        # Gaming
        mangohud
        goverlay
        protonup-qt
        lutris
        heroic
        prismlauncher
        gamescope
        vulkan-tools

        # Developer
        vscodium
        git
        gh
        nodejs_22
        pnpm
        python3
        python3Packages.pip
        python3Packages.virtualenv
        gcc
        gnumake
        cmake
        go
        sqlite
        lazygit
        direnv
        nil

        # System tools
        curl
        wget
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
  '';

  shieldInstallVm = pkgs.writeShellApplication {
    name = "shield-install-vm";
    runtimeInputs = with pkgs; [ coreutils util-linux e2fsprogs dosfstools gawk gnugrep ];
    text = ''
      set -euo pipefail

      ROOT=""
      EFI=""
      FORCE_EXISTING="no"

      usage() {
        cat >&2 <<'EOF'
ShieldOS safe VM installer

This installer DOES NOT wipe disks, does NOT repartition, and does NOT format.
You must give it existing partitions that you already created/formatted.

Usage:
  sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1

Optional:
  --force-into-existing-root   allow installing into a root partition that already has system folders

Recommended VM partition layout:
  /dev/vda1  EFI partition, FAT32, about 1 GiB
  /dev/vda2  Linux root partition, ext4, rest of disk

Helpful commands:
  lsblk -f
  sudo fdisk -l
EOF
      }

      if [ "$(id -u)" -ne 0 ]; then
        echo "Run this as root." >&2
        usage
        exit 1
      fi

      while [ "$#" -gt 0 ]; do
        case "$1" in
          --root)
            ROOT="''${2:-}"
            shift 2
            ;;
          --efi)
            EFI="''${2:-}"
            shift 2
            ;;
          --force-into-existing-root)
            FORCE_EXISTING="yes"
            shift
            ;;
          -h|--help)
            usage
            exit 0
            ;;
          *)
            echo "Unknown argument: $1" >&2
            usage
            exit 2
            ;;
        esac
      done

      if [ -z "$ROOT" ] || [ -z "$EFI" ]; then
        usage
        echo
        echo "Detected block devices:"
        lsblk -f
        exit 2
      fi

      if [ ! -b "$ROOT" ]; then
        echo "Root partition is not a block device: $ROOT" >&2
        exit 2
      fi

      if [ ! -b "$EFI" ]; then
        echo "EFI partition is not a block device: $EFI" >&2
        exit 2
      fi

      ROOT_TYPE="$(lsblk -dnpo TYPE "$ROOT" | awk '{print $2}')"
      EFI_TYPE="$(lsblk -dnpo TYPE "$EFI" | awk '{print $2}')"

      if [ "$ROOT_TYPE" = "disk" ] || [ "$EFI_TYPE" = "disk" ]; then
        echo "Refusing to install to a whole disk." >&2
        echo "Use partitions only, for example /dev/vda2 for root and /dev/vda1 for EFI." >&2
        exit 2
      fi

      ROOT_FSTYPE="$(lsblk -dnpo FSTYPE "$ROOT" | awk '{print $2}')"
      EFI_FSTYPE="$(lsblk -dnpo FSTYPE "$EFI" | awk '{print $2}')"

      if [ -z "$ROOT_FSTYPE" ]; then
        echo "Root partition has no filesystem. Format it yourself first, for example ext4." >&2
        echo "This installer will not format it because it is non-wiping by design." >&2
        exit 2
      fi

      case "$EFI_FSTYPE" in
        vfat|fat|fat32) ;;
        *)
          echo "EFI partition must be FAT32/vfat. Current filesystem: ''${EFI_FSTYPE:-none}" >&2
          echo "This installer will not format it because it is non-wiping by design." >&2
          exit 2
          ;;
      esac

      umount -R /mnt 2>/dev/null || true
      mkdir -p /mnt
      mount "$ROOT" /mnt

      if [ "$FORCE_EXISTING" != "yes" ]; then
        if [ -e /mnt/nix ] || [ -e /mnt/etc ] || [ -e /mnt/bin ] || [ -e /mnt/usr ]; then
          echo "The root partition is not empty or already contains system folders." >&2
          echo "Nothing was deleted." >&2
          echo "Use a fresh empty root partition, or rerun with --force-into-existing-root if you know what you are doing." >&2
          umount -R /mnt 2>/dev/null || true
          exit 3
        fi
      fi

      mkdir -p /mnt/boot
      mount "$EFI" /mnt/boot
      mkdir -p /mnt/etc/nixos

      nixos-generate-config --root /mnt

      if [ -f /mnt/etc/nixos/configuration.nix ]; then
        cp /mnt/etc/nixos/configuration.nix "/mnt/etc/nixos/configuration.nix.backup.$(date +%Y%m%d-%H%M%S)"
      fi

      cp ${installedConfig} /mnt/etc/nixos/configuration.nix

      echo
      echo "Installing ShieldOS Daily Driver without wiping or formatting disks..."
      echo "Root: $ROOT"
      echo "EFI:  $EFI"
      echo
      nixos-install --no-root-passwd

      echo
      echo "Install complete. Reboot, remove the ISO, then log in:"
      echo "  username: shield"
      echo "  password: shield"
      echo
      echo "Change the password after first login with: passwd"
    '';
  };

in {
  environment.systemPackages = [ shieldInstallVm ];

  environment.etc."xdg/applications/shield-installer.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Install ShieldOS Safely
    Comment=Install ShieldOS using existing partitions without wiping the disk
    Exec=konsole -e bash -lc "echo 'Safe installer does not wipe, partition, or format.'; echo 'Usage: sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1'; echo; lsblk -f; echo; bash"
    Icon=drive-harddisk
    Terminal=false
    Categories=System;
  '';
}
