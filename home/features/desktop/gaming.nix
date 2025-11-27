{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
with lib; let
  retroarchWithCores = (
    pkgs.retroarch.withCores (
      # NES N64 SNES.
      cores: with cores; [ fceumm mupen64plus snes9x ]
    )
  );
  cfg = config.features.desktop.gaming;
in {
  options.features.desktop.gaming.enable =
    (mkEnableOption "enable gaming features") //
    { default = osConfig.extraServices.gaming.enable or false; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #ankama-launcher      # Dofus. Not working at the moment.
      gdstash               # Infinite stash for Grim Dawn.
      retroarchWithCores    # Retrogaming.
      x16-run
    ];

    # Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load
    # and more.
    programs.mangohud = {
      enable = true;
      settings = lib.mkAfter {
        cpu_stats = true;
        cpu_temp = true;
        gpu_stats = true;
        gpu_temp = true;
        vram = true;
        ram = true;
        fps = true;
        frametime = true;
        mangoapp_steam = true;
        position = "top-right";
        font_size = lib.mkForce 24;
        font_size_text = lib.mkForce 24;
      };
    };
  };
}