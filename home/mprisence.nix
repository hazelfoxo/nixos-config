{ pkgs, ... }:

{
  # Include the mprisense cmd tool
  home.packages = [
    pkgs.mprisence
  ];

  # Create a config to enable youtube detection
  home.file.".config/mprisence/config.toml".text = ''
    [web_player.youtube]
    ignore = false
  '';
}
