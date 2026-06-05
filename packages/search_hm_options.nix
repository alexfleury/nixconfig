{
  bashNonInteractive,
  xdg-utils,
  writeShellApplication,
}:
let
  template_script = builtins.readFile ../scripts/websearch.bash;
  path = "$HOME/.search_hm_options.hist";
  url = "https://home-manager-options.extranix.com/?query=";
in writeShellApplication {
  name = "search-hm-options";
  runtimeInputs = [ bashNonInteractive xdg-utils ];
  text = builtins.replaceStrings ["@history_file@" "@base_url@"] [path url] template_script;
}