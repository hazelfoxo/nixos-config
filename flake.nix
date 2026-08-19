{
  description = "Hazie's Desktop PCs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-vscode-extensions.url =
      "github:nix-community/nix-vscode-extensions";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      overlay = import ./overlays/default.nix;

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ overlay ];
      };
    in {
      overlays.default = overlay;

      packages.${system}.spotify-adblock = pkgs.spotify-adblock;

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./hosts/desktop

          {
            nixpkgs.overlays = [ self.overlays.default ];
          }

          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.hazie = import ./home/home.nix;
          }
        ];
      };
    };
}
