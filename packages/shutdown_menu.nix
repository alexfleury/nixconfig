{
  bashNonInteractive,
  writeShellApplication,
  rofi,
  systemd,
  hyprland,
}:
writeShellApplication {
  name = "shutdown-menu";

  runtimeInputs = [
    bashNonInteractive
    rofi
    systemd
  ];

  text = ''
    choice=$(
      printf '%s\n' \
        " Lock" \
        "󰋣 Hibernate" \
        "󰜉 Reboot" \
        "󰐥 Shutdown" \
      | rofi -dmenu -i -p "Power" -lines 4
    )

    case "$choice" in
      " Lock")
        loginctl lock-session
        ;;
      "󰋣 Hibernate")
        systemctl hibernate
        ;;
      "󰜉 Reboot")
        systemctl reboot
        ;;
      "󰐥 Shutdown")
        systemctl poweroff
        ;;
    esac
  '';
}