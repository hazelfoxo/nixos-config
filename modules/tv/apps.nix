{ pkgs, ... }:

{
    # Define user programs and applications
    environment.systemPackages  = with pkgs; [
        vacuum-tube
    ];
}
