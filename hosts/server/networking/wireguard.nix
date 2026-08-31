{ ... }:

{
  my.server.wireguard = {
    enable = true;
    address = [ "10.0.0.1/24" ];
    peers = {
      laptop = {
        publicKey = "LIraGHV+u4GN8QNSMo8MhOtX/sDQecQ/w9uY57H+sl4=";
        allowedIPs = [ "10.0.0.2/32" ];
      };
      iPhone = {
        publicKey = "11Se4L5MQu39OOU0f372f5lkeeI78oUkCTbVN4jgxno=";
        allowedIPs = [ "10.0.0.3/32" ];
      };
      desktop = {
        publicKey = "mbY8t2dV3wF9P+R/IWq9k5p2aEIkTKz4VxwJmUYUhWo=";
        allowedIPs = [ "10.0.0.4/32" ];
      };
    };
  };
}
