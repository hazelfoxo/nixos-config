{config,  ... }:
{
  my.ssh = {
    enable = true;
  
    name = "homeserver";
    address = "10.0.0.1";
    port = 2222;

    user = "hazie";

    knownHostKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDPT/09Fl/p124dDSh7TE41JTYHPTtnZJZwR8uh67XEA root@homeserver";
  };
}