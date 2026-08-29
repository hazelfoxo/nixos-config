{config,  ... }:

{
  my.ssh = {
    enable = true;

    owner = "hazie";

    hosts = {
      homeserver = {
        address = "10.0.0.1";
        user = "hazie";
        port = 2222;

        privateKeySecret = "homeserver_ssh_private_key";

        knownHostKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPT/09Fl/p124dDSh7TE41JTYHPTtnZJZwR8uh67XEA root@homeserver";
      };

    };

  };
}