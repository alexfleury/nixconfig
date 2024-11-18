{ ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = true;
        lock_cmd = "pidof hyprlock || hyprlock";
      };

      listener = [
        #{
        #  timeout = 300;
        #  on-timeout = "ddcutil dumpvcp ~/.local/share/ddcutil/restore.vcp && ddcutil setvcp 10 1";
        #  on-resume = "ddcutil loadvcp ~/.local/share/ddcutil/restore.vcp";
        #}
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 3600;
          on-timeout = "systemctl hibernate";
        }
      ];
    };
  }; # End of services.hypridle
}