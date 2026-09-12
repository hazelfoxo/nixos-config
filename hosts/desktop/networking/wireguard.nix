{ ... }:

# Wireguard VPN configuration for the desktop host

{
  my.wireguard.profiles."Home VPN" = {
    privateKeySecret = "homeserver-wg-private-key";
    interface = "wg0";
    address = [ "10.0.0.4/32" ];
    serverPublicKey = "SY57GcLr+gbxxN278xyepRXm37ZbLikM5+b4pRp+anQ=";
    endpoint = "hazie.duckdns.org:51820";
    allowedIPs = [ "10.0.0.1/32" ];
    neverDefault = true;
  };
}
