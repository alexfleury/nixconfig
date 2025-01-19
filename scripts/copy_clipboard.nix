{ pkgs }:

pkgs.writeShellApplication {
  name = "copy_clipboard";

  runtimeInputs = with pkgs; [ wl-clipboard xclip ];

  text = ''
    wl-paste | xclip -selection clipboard
  '';
}