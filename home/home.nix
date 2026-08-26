{  ... }:

{
  home = {
    username = "hazie";
    homeDirectory = "/home/hazie";
    stateVersion = "26.05";
  };

  # Import Home-manager modules
   imports = [
    ./programs
    ./desktop
  ];

}
