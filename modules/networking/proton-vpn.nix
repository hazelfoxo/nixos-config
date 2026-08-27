{pkgs, ... }:

{
    networking.firewall.checkReversePath = false;

    environment.systemPackages = with pkgs; [
        proton-vpn
    ];
}
