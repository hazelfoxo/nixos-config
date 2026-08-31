  { ... }:

  {
    imports = [
      ./locale.nix
      ./system.nix
      ./nix.nix
      ./packages.nix
      ./fonts.nix
      ./programs.nix
      ./users.nix
      ./boot
      ./secrets.nix
      ./home-manager.nix
      ./nixpkgs.nix
    ];
  }
