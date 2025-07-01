{ config, pkgs, ... }:

{
  programs.borgmatic = {
    enable = true;
    backups = {

      data = {

        hooks.extraConfig = {
          commands = [
            {
              before = "repository";
              run = [
                "findmnt {repository_label} > /dev/null || exit 75"
                "findmnt /mnt/Data > /dev/null || exit 75"
              ];
            }
          ];
        };

        location = {

          patterns = [
            "R /mnt/Data"
            "- mnt/Data/SteamLibrary"
            "- mnt/Data/ProtonDrive"
            "R /home/${config.home.username}/.ssh"
            "- .ssh/config"
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

        # TODO: add encryption.
        #storage.encryptionPasscommand = "${pkgs.password-store}/bin/pass borg-repo";
      };

      grimdawn = {

        hooks.extraConfig = {
          commands = [
            {
              before = "repository";
              run = [
                "findmnt /mnt/Data > /dev/null || exit 75"
              ];
            }
          ];
        };

        location = {
          sourceDirectories = [
            "${config.home.homeDirectory}/.local/share/Steam/steamapps/compatdata/219990/pfx/drive_c/users/steamuser/Documents/My Games/Grim Dawn/save"
            "${config.home.homeDirectory}/GDStash"
          ];

          repositories = [
            {
              path = "/mnt/Data/GDSaves";
              label = "/mnt/Data";
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
      };

    };
  };
}
