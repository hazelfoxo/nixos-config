{
  description = "Hazie's NixOS systems";

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

      mkSystem = host:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;
          };

          modules = [
            ./hosts/${host}

            home-manager.nixosModules.home-manager

            {
              nixpkgs.overlays = [ overlay ];

              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs;
                };

                users.hazie = import ./home/home.nix;
              };
            }
          ];
        };
    in
    {
      overlays.default = overlay;

      packages.${system}.spotify-adblock = pkgs.spotify-adblock;

      nixosConfigurations = {
        desktop = mkSystem "desktop";
        laptop = mkSystem "laptop";
      };
    };
}
