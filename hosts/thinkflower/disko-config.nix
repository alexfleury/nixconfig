let
  sdaId = "nvme-Micron_2300_NVMe_512GB__21112E209A6D";
in
{
  disko.devices = {
    disk = {
      nixos = {
        device = "/dev/disk/by-id/${sdaId}";
        type = "disk";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
              type = "EF00";
              size = "2G";

              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };

            swap = {
              size = "16G";

              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };

            root = {
              size = "100%";

              content = {
                type = "btrfs";

                extraArgs = [
                  "-L"
                  "system"
                ];

                subvolumes = {
                  root = {
                    mountpoint = "/";
                  };

                  home = {
                    mountpoint = "/home";
                  };

                  nix = {
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}