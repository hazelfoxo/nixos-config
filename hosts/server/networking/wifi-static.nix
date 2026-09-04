{ ... }:

{
  my.wifi = {
    enable = true;
    ipv4 = {
      method = "manual";
      address = "192.168.1.200/24";
      gateway = "192.168.1.1";
      dns = [
        "1.1.1.1"
        "9.9.9.9"
      ];
    };
  };
}
