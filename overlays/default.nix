{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../packages { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    {
      video2x = prev.video2x.override { ffmpeg = prev.ffmpeg-full; };
      steam = prev.steam.override { extraProfile = "export GDK_SCALE=2"; };
    };
}
