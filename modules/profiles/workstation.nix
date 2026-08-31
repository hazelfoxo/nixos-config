{ ... }:

{

  imports = [
    ./ssh.nix

    ../hardware
    ../features/desktop
    ../networking
    ../features/gaming
    ../features/video-editing
  ];
}
