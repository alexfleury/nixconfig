{
  bashNonInteractive,
  xdg-utils,
  writeShellApplication,
}:
let
  template_script = builtins.readFile ../scripts/websearch.bash;
  path = "$HOME/.search_mynixos.hist";
  url = "https://mynixos.com/search?q=";
in writeShellApplication {
  name = "search-mynixos";
  runtimeInputs = [ bashNonInteractive xdg-utils ];
  text = builtins.replaceStrings ["@history_file@" "@base_url@"] [path url] template_script;
}