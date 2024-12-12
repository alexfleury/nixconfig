{ config, pkgs, ... }:

{
  programs.borgmatic = {
    enable = true;
    backups = {

      data = {

        hooks.extraConfig = {
          "before_backup" = [
            "findmnt {repository_label} > /dev/null || exit 75"
            "findmnt /mnt/Data > /dev/null || exit 75"
          ];
        };

        location = {

          patterns = [
            "R /mnt/Data"
            "- mnt/Data/Audio/Musique/mp3"
            "- mnt/Data/Films/mp4"
            "- mnt/Data/Series/mp4"
            "- mnt/Data/SteamLibrary"
            "- mnt/Data/ProtonDrive"
          ];
          repositories = [
            {
              path = "/run/media/${config.home.username}/SSD_2TB/DataBackups";
              label = "/run/media/${config.home.username}/SSD_2TB";
            }
            {
              path = "/run/media/${config.home.username}/HDD_1TB/DataBackups";
              label = "/run/media/${config.home.username}/HDD_1TB";
            }
          ];
        };

        retention = {
          keepDaily = 1;
          keepMonthly = 1;
          keepYearly = -1;
        };

        output.extraConfig = {
          archive_name_format = "{hostname}_{now}";
        };

        #storage.encryptionPasscommand = "${pkgs.password-store}/bin/pass borg-repo";
      }; # End of backups.data.

      grimdawn = {

        hooks.extraConfig = {
          "before_backup" = [
            "findmnt /mnt/Data > /dev/null || exit 75"
          ];
        };

        location = {
          sourceDirectories = [
            "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/219990/pfx/drive_c/users/steamuser/Documents/My Games/Grim Dawn/save"
            "${config.home.homeDirectory}/GDStash"
          ];

          repositories = [
            {
              path = "/mnt/Data/ProtonDrive/GDSaves";
              label = "protondrive";
            }
          ];
        };

        retention = {
          keepDaily = 1;
          keepMonthly = 1;
          keepYearly = -1;
        };

        output.extraConfig = {
          archive_name_format = "gdsave_{now}";
        };
      }; # End of backups.grimdawn.

    };
  };
}
