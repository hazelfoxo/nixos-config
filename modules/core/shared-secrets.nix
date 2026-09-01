{ lib, ... }:

{
  options.my.sharedSecrets = {
    enable = lib.mkEnableOption "the shared SOPS secrets file";
    file = lib.mkOption {
      type = lib.types.path;
      default = ../../secrets/shared.yaml;
      description = "Shared SOPS file used by opted-in profiles.";
    };
  };
}
