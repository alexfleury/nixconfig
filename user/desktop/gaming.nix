{ pkgs, ... }:
let
  retroarchWithCores = (
    pkgs.retroarch.withCores (
      cores: with cores; [
        fceumm # NES.
        mupen64plus # N64.
        snes9x # SNES.
      ]
    )
  );
in
{

  home.packages = with pkgs; [
    # Infinite stash for Grim Dawn.
    gdstash
    # Retrogaming.
    retroarchWithCores
    x16-run
    # For Battle.net games.
    wineWowPackages
    winetricks
  ];

  # Vulkan and OpenGL overlay for monitoring FPS, temperatures, CPU/GPU load and more.
  programs.mangohud = {
    enable = true;
    settings = {
      mangoapp_steam = true;
    };
  };

}
