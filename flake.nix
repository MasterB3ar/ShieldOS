{
  description = "ShieldOS Developer Preview - easy, private, polished desktop OS based on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.shieldos-iso = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/iso/configuration.nix
        ];
      };
    };
}
