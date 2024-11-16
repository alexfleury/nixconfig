{ ... }:

{
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";
    settings = {
      device_config = [
        {
        device_file = "/dev/sda1";
        ignore = true;
        }
        {
        device_file = "/dev/sdb1";
        ignore = true;
        }
      ];
    };
  }; # End of services.udiskie
}
