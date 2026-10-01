{
  config,
  lib,
  pkgs,
  ...
}:

# Creative/art profile configuration for NixOS hosts

let
  cfg = config.my.profiles.creative;
in
{
  options.my.profiles.creative = {
    painting.enable = lib.mkEnableOption "digital painting tools (Krita, MyPaint)";
    vector.enable = lib.mkEnableOption "vector graphics tools (Inkscape)";
    raster.enable = lib.mkEnableOption "raster image editing (GIMP)";
    photo.enable = lib.mkEnableOption "photo processing (Darktable, RawTherapee)";
    video = {
      editor.enable = lib.mkEnableOption "video editing (Kdenlive)";
      tools.enable = lib.mkEnableOption "video encoding tools (ffmpeg, HandBrake)";
    };
    threeD.enable = lib.mkEnableOption "3D modeling tools (Blender, FreeCAD)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.painting.enable {
      environment.systemPackages = with pkgs; [
        krita
      ];
    })

    (lib.mkIf cfg.vector.enable {
      environment.systemPackages = with pkgs; [
        inkscape
      ];
    })

    (lib.mkIf cfg.raster.enable {
      environment.systemPackages = with pkgs; [
        gimp
      ];
    })

    (lib.mkIf cfg.photo.enable {
      environment.systemPackages = with pkgs; [
        darktable
        rawtherapee
      ];
    })

    (lib.mkIf cfg.video.editor.enable {
      environment.systemPackages = with pkgs; [
        kdePackages.kdenlive
      ];
    })

    (lib.mkIf cfg.video.tools.enable {
      environment.systemPackages = with pkgs; [
        ffmpeg
        handbrake
      ];
    })

    (lib.mkIf cfg.threeD.enable {
      environment.systemPackages = with pkgs; [
        blender
        freecad
      ];
    })
  ];
}
