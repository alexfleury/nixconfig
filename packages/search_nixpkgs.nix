{
  bashNonInteractive,
  xdg-utils,
  writeShellApplication,
}:
let
  template_script = builtins.readFile ../scripts/websearch.bash;
  path = "$HOME/.search_nixpkgs.hist";
  url = "https://search.nixos.org/packages?channel=unstable&query=";
in writeShellApplication {
  name = "search-nixpkgs";
  runtimeInputs = [ bashNonInteractive xdg-utils ];
  text = builtins.replaceStrings ["@history_file@" "@base_url@"] [path url] template_script;
}