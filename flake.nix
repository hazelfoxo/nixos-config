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

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ nixpkgs, ... }:

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
            ./modules/common.nix
          ];

        };

    in {

      nixosConfigurations = {
        desktop = mkSystem "desktop";
        laptop = mkSystem "laptop";
      };

    };

}
