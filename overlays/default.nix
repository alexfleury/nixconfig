{
  # Import custom packages from the "packages" directory.
  additions = final: _prev: import ../packages { pkgs = final; };

  # Change versions, add patches, set compilation flags, ...
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    video2x = prev.video2x.override { ffmpeg = prev.ffmpeg-full; };
    steam = prev.steam.override { extraProfile = "export GDK_SCALE=2"; };
  };
}
