{ ... }:

{
  sops.defaultSopsFile = ../../../secrets/laptop.yaml;

  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.age.generateKey = true;

  sops.secrets.test_secret = {};
}