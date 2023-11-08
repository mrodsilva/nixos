{
  description = "Nixos - Flake Configuration";

  inputs = {

    # Packge repo for nixos
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-23.05";
    };

  };

  outputs = { self, nixpkgs, ... }:
    let 
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}