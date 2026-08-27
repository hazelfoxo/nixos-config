{config,  ... }:
{
  my.ssh = {
    enable = true;

    host = "10.0.0.1";
    user = "hazie";

    knownHostKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC2rG5gept2w78AwGABaiV7e68OLzMdgREHqKeAixb4V hazie@hazie-laptop";
  };
}