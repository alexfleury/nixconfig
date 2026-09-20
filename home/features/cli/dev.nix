{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.dev;
in {
  options.features.cli.dev.enable = mkEnableOption "enable dev tools";

  config = mkIf cfg.enable {
    programs.uv = {
      enable = true;
      python = {
        default = "3.13";
        versions = [ "3.13" ];
        prune = true;
      };
      settings = {
        # Prefer uv-managed Python installations.
        python-preference = "only-managed";
        # Don't automatically download Python versions unless explicitly
        # requested/managed above.
        python-downloads = "manual";
        # Faster startup for installed Python applications.
        compile-bytecode = true;
      };
      tool.prune = true;
    };
  };
}