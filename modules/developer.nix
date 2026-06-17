{ config, lib, pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
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
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
