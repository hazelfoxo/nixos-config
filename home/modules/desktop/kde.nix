{ osConfig, ... }:

{
  programs.plasma = {
    enable = osConfig.my.features.desktop.kde.enable;

    workspace.wallpaper = osConfig.my.features.desktop.kde.wallpaper;

    configFile = {
      kdeglobals.General = {
        accentColorFromWallpaper = true;
        fixed = "CaskaydiaCove Nerd Font,10,...";
        XftAntialias = true;
        XftHintStyle = "hintslight";
        XftSubPixel = "rgb";
      };

      katerc."KTextEditor Renderer"."Text Font" =
        "CaskaydiaCove Nerd Font,...";

      kwinrc.Plugins = {
        magiclampEnabled = true;
        squashEnabled = false;
        blurEnabled = true;
      };

      kwinrc.Wayland.EnablePrimarySelection = false;

      kiorc.Confirmations = {
        ConfirmDelete = true;
        ConfirmEmptyTrash = true;
      };

      krunnerrc.Plugins = {
        baloosearchEnabled = false;
        browserhistoryEnabled = false;
        browsertabsEnabled = false;
        helprunnerEnabled = false;
        krunner_appstreamEnabled = false;
        krunner_bookmarksrunnerEnabled = false;
        krunner_charrunnerEnabled = false;
        krunner_katesessionsEnabled = false;
        krunner_konsoleprofilesEnabled = false;
        krunner_placesrunnerEnabled = false;
        krunner_recentdocumentsEnabled = false;
        krunner_sessionsEnabled = false;
        krunner_spellcheckEnabled = true;
        krunner_webshortcutsEnabled = false;
        locationsEnabled = false;
        "org.kde.activities2Enabled" = false;
        "org.kde.datetimeEnabled" = false;
        unitconverterEnabled = true;
        windowsEnabled = false;
      };

      krunnerrc."Plugins/Favorites".plugins =
        "krunner_powerdevil,krunner_services,krunner_systemsettings";

      spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
      spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
      spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";
    };

    shortcuts = {
      "services/kitty.desktop"._launch = "Meta+Return";
    };
  };
}
