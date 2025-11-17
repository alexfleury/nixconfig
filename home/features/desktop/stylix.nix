{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.stylix;
in {
  options.features.desktop.stylix.enable =
    (mkEnableOption "enable stylix home-manager options") //
    { default = osConfig.extraServices.stylix.enable or false; };

  config = mkIf cfg.enable {
    stylix.iconTheme = {
      enable = true;
      package = pkgs.dracula-icon-theme;
      dark = "Dracula";
    };
  };
}