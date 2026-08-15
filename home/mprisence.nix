{ pkgs, ... }:

{
  home.packages = [
    pkgs.mprisence
  ];

  home.file.".config/mprisence/config.toml".text = ''
    [web_player.youtube]
    ignore = false
  '';
}
