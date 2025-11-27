{
  bashNonInteractive,
  writeShellApplication,
  zenity,
}:
writeShellApplication {
  name = "zoom75-info";
  runtimeInputs = [ bashNonInteractive zenity ];
  text = builtins.readFile ../scripts/zoom75_info.bash;
}