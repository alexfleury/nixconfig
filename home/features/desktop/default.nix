{
  lib,
  osConfig,
  ...
}:
let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
  autoImports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./.))
  );
in {
  imports = autoImports;

  services.blueman-applet.enable = osConfig.services.blueman.enable;
}
