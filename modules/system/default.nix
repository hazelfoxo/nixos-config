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
    ./plymouth.nix
    ./boot.nix
  ];
}
