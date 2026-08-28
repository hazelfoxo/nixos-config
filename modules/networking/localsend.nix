{
    # Localsend Firewall Overrides to enable file receiving
    networking.firewall = {
        allowedTCPPorts = [ 53317 ];
        allowedUDPPorts = [ 53317 ];
    };
}
