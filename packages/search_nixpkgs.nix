{ pkgs }:
let
  template_script = builtins.readFile ../scripts/websearch.bash;
  path = "$HOME/.search_nixpkgs.hist";
  url = "https://search.nixos.org/packages?channel=unstable&query=";
in
pkgs.writeShellApplication {
  name = "search-nixpkgs";
  runtimeInputs = with pkgs; [ bashNonInteractive firefox ];
  text = builtins.replaceStrings ["@history_file@" "@base_url@"] [path url] template_script;
}