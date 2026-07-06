{
  # Import custom packages from the "packages" directory.
  additions = final: _prev: import ../packages { pkgs = final; };

  # Change versions, add patches, set compilation flags, ...
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {

    #video2x = prev.video2x.override { ffmpeg = prev.ffmpeg-full; };

    steam = prev.steam.override {
      extraProfile = "export GDK_SCALE=2";
    };

    # https://github.com/ValveSoftware/gamescope/issues/1622
    #gamescope = prev.gamescope.overrideAttrs (_: {
    #  NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
    #});

    # https://github.com/NixOS/nixpkgs/issues/513245#issuecomment-4317696552
    #openldap = prev.openldap.overrideAttrs (_: {
    #  doCheck = !prev.stdenv.hostPlatform.isi686;
    #});

    #waybar = prev.waybar.overrideAttrs (old: rec {
    #  version = "git";
    #  src = prev.fetchFromGitHub {
    #    owner = "Alexays";
    #    repo = "Waybar";
    #    rev = "master";
    #    hash = "sha256-urC1njV+FyrskLdTw0G8/MKPgEM7UjLx0M1BVfeI2rE=";
    #};
    #});
  };
}
