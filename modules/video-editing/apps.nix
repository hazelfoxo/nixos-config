{ pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        kdenlive
        ffmpeg
    ];
}
