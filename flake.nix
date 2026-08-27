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

    spotx-nix = {
      url = "github:SpotX-Official/SpotX-Nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

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
              nixpkgs = {
                overlays = [
                  inputs.spotx-nix.overlays.default
                ];

                config.allowUnfreePredicate = pkg:
                  builtins.elem (nixpkgs.lib.getName pkg) [
                    "spotify"
                    "spotify-spotx"
                  ];
              };

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
      nixosConfigurations = {
        desktop = mkSystem "desktop";
        laptop = mkSystem "laptop";
      };
    };
}
