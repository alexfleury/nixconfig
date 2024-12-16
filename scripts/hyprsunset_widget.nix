{ pkgs }:

pkgs.writeShellApplication {
  name = "hyprsunset_widget";

  text = ''
    if pgrep -x hyprsunset >/dev/null; then
      printf '{"text": "", "class": "enabled"}';
    else
      printf '{"text": "", "class": "disabled"}';
    fi
  '';
}