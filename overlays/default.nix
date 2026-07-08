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

    waybar = prev.waybar.overrideAttrs (old: rec {
      version = "0.15.0-unstable";
      doInstallCheck = false;

      buildInputs = (old.buildInputs or []) ++ [
        final.libcava
        final.modemmanager
      ];

      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
        final.pkg-config
      ];

      src = prev.fetchFromGitHub {
        owner = "Alexays";
        repo = "Waybar";
        rev = "98b2a563f398f63f99ec8a6f7fb2b19a172abd5d";
        hash = "sha256-gVYj72W4L5FJwtfkT/m8PxgDKBT/3HIq1BdnxhFtlPQ=";
      };
    });
  };
}
