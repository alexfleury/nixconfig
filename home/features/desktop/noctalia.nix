{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.wayle;
in {
  options.features.desktop.noctalia.enable = mkEnableOption "enable noctalia service";

  config = mkIf cfg.enable {

    program.noctalia = {
      enable = true;

      systemd.enable = true;

      #settings = {
      #};
    };

    #hl.layer_rule({
    #  name = "noctalia-no-anim",
    #  match = {
    #    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    #  },
    #  no_anim = true,
    #})
    #hl.layer_rule({
    #  name = "noctalia-blur",
    #  match = {
    #    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    #  },
    #  ignore_alpha = 0.5,
    #  blur = true,
    #  blur_popups = true,
    #})

  };
}