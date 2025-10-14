{
  disko.devices = {
    disk = {
      system = {

        type = "disk";
        device = "/dev/vdb";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            }; # Enf of ESP

            luks = {
              size = "100%";

              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                #passwordFile = "/tmp/secret.key"; # Interactive
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key";
                };

                additionalKeyFiles = [ "/tmp/additionalSecret.key" ];

                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/home" = {
                      mountpoint = "/home";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "/swap" = {
                      mountpoint = "/.swapvol";
                      swap.swapfile.size = "20M";
                    };
                  };
                };

              };
            }; # End of luks.

          }; # End of partition.
        }; # End of content.
      }; # Enf of system.



      hdda = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            crypt_p1 = {
              size = "100%";
              content = {
                type = "luks";
                name = "data1"; # device-mapper name when decrypted
                # Remove settings.keyFile if you want to use interactive password entry
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key";
                };
              };
            };
          };
        };
      };
      hddb = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            crypt_p2 = {
              size = "100%";
              content = {
                type = "luks";
                name = "p2";
                # Remove settings.keyFile if you want to use interactive password entry
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key"; # Same key for both devices
                };
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-d raid1"
                    "/dev/mapper/data1" # Use decrypted mapped device, same name as defined in disk1
                  ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "rw"
                        "relatime"
                        "ssd"
                      ];
                    };
                  };
                };
              };
            };
          };
        };
      };


    }; # End of disk.
  };
}