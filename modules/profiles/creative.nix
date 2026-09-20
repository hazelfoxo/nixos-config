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
    enable = lib.mkEnableOption "the creative profile";

    painting.enable = lib.mkEnableOption "digital painting tools (Krita, MyPaint)";
    vector.enable = lib.mkEnableOption "vector graphics tools (Inkscape)";
    raster.enable = lib.mkEnableOption "raster image editing (GIMP)";
    photo.enable = lib.mkEnableOption "photo processing (Darktable, RawTherapee)";
    threeD.enable = lib.mkEnableOption "3D modeling tools (Blender, FreeCAD)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        krita
        gimp
        inkscape
        mypaint
        blender
        darktable
        rawtherapee
        freecad
      ];
    })

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

    (lib.mkIf cfg.threeD.enable {
      environment.systemPackages = with pkgs; [
        blender
        freecad
      ];
    })
  ];
}
