{
  lib,
  osConfig,
  ...
}:
{
  imports = lib.autoImports ./.;

  services.blueman-applet.enable = osConfig.services.blueman.enable;
}
