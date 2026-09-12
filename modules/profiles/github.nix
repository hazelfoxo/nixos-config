{
  config,
  lib,
  ...
}:

# GitHub SSH access profile for NixOS hosts

{
  options.my.profiles.github.enable = lib.mkEnableOption "the GitHub SSH access profile";

  config = lib.mkIf config.my.profiles.github.enable {
    my.ssh = {
      enable = true;

      owner = "hazie";

      hosts = {
        "github-personal" = {
          address = "github.com";
          user = "git";

          sopsKey = "github-ssh-private-key";

          knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        };
      };

    };
  };
}
