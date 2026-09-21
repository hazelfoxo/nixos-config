{
  description = "Hazie's NixOS systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    spotx-nix = {
      url = "github:SpotX-Official/SpotX-Nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:

    let

      system = "x86_64-linux";

      hosts = {
        desktop = {
          hostName = "hazie-pc";
          sopsFile = ./secrets/hosts/desktop.yaml;
        };

        laptop = {
          hostName = "hazie-laptop";
          sopsFile = ./secrets/hosts/laptop.yaml;
        };

        huawei = {
          hostName = "hazie-huawei";
          sopsFile = ./secrets/hosts/huawei.yaml;
        };

        server = {
          hostName = "hazie-server";
          sopsFile = ./secrets/hosts/server.yaml;
        };
      };

      # Build a system from a host name and its metadata declared above.
      mkSystem =
        name: hostConfig:

        nixpkgs.lib.nixosSystem {

          inherit system;

          specialArgs = {
            # Only flake-boundary modules may touch these: ./modules/core
            # (which loads the home-manager/sops/lanzaboote modules and
            # populates `my.inputs`) and hosts/laptop (disko).
            inherit inputs;

            # Per-host metadata consumed by the my.host option wiring below.
            host = hostConfig // {
              inherit name;
            };
          };

          modules = [
            # Shared base applied to every host. It wires up flake module
            # inputs (home-manager, sops, ...) and provides the my.* options.
            ./modules/core

            ./hosts/${name}

            # Populate the my.host option from the host definition above.
            ({ host, ... }: {
              my.host = {
                name = host.name;
                hostName = host.hostName;
                sopsFile = host.sopsFile;
              };
            })
          ];

        };

    in
    {

      packages.${system}.disko = inputs.disko.packages.${system}.disko;

      nixosConfigurations = nixpkgs.lib.mapAttrs mkSystem hosts;

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;

      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        packages = [
          nixpkgs.legacyPackages.${system}.sops
          nixpkgs.legacyPackages.${system}.nixfmt
        ];
      };

    };

}
