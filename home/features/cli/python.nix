{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.python;
in {
  options.features.cli.python.enable = mkEnableOption "enable python development tools";

  config = mkIf cfg.enable {
    programs.uv = {
      enable= true;
      settings = {
        python-downloads = "never";
      };
    };
  };
}