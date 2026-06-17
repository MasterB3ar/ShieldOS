{ config, lib, pkgs, ... }:

let
  optionalPkg = name: lib.optional (builtins.hasAttr name pkgs) (builtins.getAttr name pkgs);
in {
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
  ]
  ++ optionalPkg "rustup"
  ++ optionalPkg "nixfmt-rfc-style"
  ++ optionalPkg "podman-compose"
  ++ optionalPkg "docker-compose";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
