{ pkgs }:
let
  template_script = builtins.readFile ../scripts/websearch.bash;
  path = "$HOME/.search_mynixos.hist";
  url = "https://mynixos.com/search?q=";
in
pkgs.writeShellApplication {
  name = "search-mynixos";
  runtimeInputs = with pkgs; [ bashNonInteractive firefox ];
  text = builtins.replaceStrings ["@history_file@" "@base_url@"] [path url] template_script;
}