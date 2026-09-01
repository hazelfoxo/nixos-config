{ pkgs, ... }:

{
  sops.age.keyFile = "/var/lib/sops-nix/device-key.txt";

  environment.systemPackages = [ pkgs.sops ];
}
