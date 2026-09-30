{ ... }:

# GitHub SSH access (my.ssh)

# Data preset, not a profile: importing this module wires up the SSH key and
# host key used to reach github.com. Nothing else is installed.

{
  my.ssh = {
    enable = true;

    owner = "hazie";

    hosts."github.com" = {
      address = "github.com";
      user = "git";

      sopsKey = "github-ssh-private-key";

      knownHostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };
}
