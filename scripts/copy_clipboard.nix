{ pkgs }:

pkgs.writeShellApplication {
  name = "copy_clipboard";

  runtimeInputs = with pkgs; [ wl-clipboard xclip ];

  text = ''
    ${pkgs.wl-clipboard}/bin/wl-paste | ${pkgs.xclip}/bin/xclip -selection clipboard
  '';
}