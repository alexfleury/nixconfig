{ pkgs }:

pkgs.writeShellApplication {
  name = "zoom75-info";
  runtimeInputs = with pkgs; [ bashNonInteractive zenity ];
  text = builtins.readFile ../../../scripts/zoom75_info.bash;
}