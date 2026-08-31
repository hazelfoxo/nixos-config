{ config, lib, pkgs, ... }:

lib.mkIf config.my.features.videoEditing.enable {
    environment.systemPackages = with pkgs; [
        kdePackages.kdenlive
        ffmpeg
        handbrake
    ];
}
