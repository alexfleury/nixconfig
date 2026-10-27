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
        "󰋣 Sleep" \
        "󰒲 Suspend-then-hibernate" \
        "󱣻 Hibernate" \
        "󰜉 Reboot" \
        "󰐥 Shutdown" \
      | rofi -dmenu -i -p "Power" -lines 4
    )

    case "$choice" in
      " Lock")
        loginctl lock-session
        ;;
      "󰋣 Sleep")
        systemctl suspend
        ;;
      "󰒲 Suspend-then-hibernate")
        systemctl suspend-then-hibernate
        ;;
      "󱣻 Hibernate")
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