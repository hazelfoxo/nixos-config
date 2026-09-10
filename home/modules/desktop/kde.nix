{ osConfig, ... }:

{
  programs.plasma = {
    enable = osConfig.my.profiles.desktop.kde.enable;

    workspace.wallpaper = osConfig.my.profiles.desktop.kde.wallpaper;
    kscreenlocker.appearance.wallpaper = osConfig.my.profiles.desktop.kde.wallpaper;
    
    input = {
      touchpads = [
        {
          name = "DLL09D9:00 04F3:3146 Touchpad";
          vendorId = "04f3";
          productId = "3146";
          enable = true;
          naturalScroll = true;
        }
      ];

      mice = [
        {
          name = "SINOWEALTH Model O Eternal";
          vendorId = "3794";
          productId = "a000";
          enable = true;
          acceleration = 0;
          accelerationProfile = "none";
        }
      ];
    };

    configFile = {
      kdeglobals.General = {
        accentColorFromWallpaper = true;
        fixed = "CaskaydiaCove Nerd Font,10,...";
        XftAntialias = true;
        XftHintStyle = "hintslight";
        XftSubPixel = "rgb";
      };

      katerc."KTextEditor Renderer"."Text Font" = "CaskaydiaCove Nerd Font,...";

      kwinrc = {
        Plugins = {
          magiclampEnabled = true;
          squashEnabled = false;
          blurEnabled = true;
        };
        Effect-blur = {
          Saturation = 275;
          BlurStrength = 8;
        };
      };

      kwinrc.Wayland.EnablePrimarySelection = false;

      kiorc.Confirmations = {
        ConfirmDelete = true;
        ConfirmEmptyTrash = true;
      };

      krunnerrc.General.FreeFloating = true;
      
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
