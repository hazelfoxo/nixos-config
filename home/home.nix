{  ... }:

{
  home = {
    username = "hazie";
    homeDirectory = "/home/hazie";
    stateVersion = "26.05";
  };

  # Import Home-manager modules
   imports = [
    ./apps.nix
    ./kde.nix
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./vscode.nix
   ./mprisence.nix
    ./appearance.nix
  ];

}
