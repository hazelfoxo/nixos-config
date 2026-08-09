{
  description = "Hazie's Desktop PCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

 outputs = { self, nixpkgs, home-manager, ... }:
{
  nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      ./hosts/desktop

      home-manager.nixosModules.home-manager

      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.hazie = import ./home/default.nix;
      }

      {
          nixpkgs.overlays = [
            (final: prev: {
              spotify-adblock = final.callPackage ./packages/spotify-adblock.nix {};
            })
          ];
        }
    ];
  };
};
}
