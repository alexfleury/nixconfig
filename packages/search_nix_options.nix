{
  bashNonInteractive,
  xdg-utils,
  writeShellApplication,
}:
let
  template_script = builtins.readFile ../scripts/websearch.bash;
  path = "$HOME/.search_nix_options.hist";
  url = "https://search.nixos.org/options?channel=unstable&query=";
in writeShellApplication {
  name = "search-nix-options";
  runtimeInputs = [ bashNonInteractive xdg-utils ];
  text = builtins.replaceStrings ["@history_file@" "@base_url@"] [path url] template_script;
}