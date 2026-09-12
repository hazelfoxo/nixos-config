{
  config,
  lib,
  ...
}:

{
  options.my.profiles.sshClient.enable = lib.mkEnableOption "the SSH client profile";

  config = lib.mkIf config.my.profiles.sshClient.enable {
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
