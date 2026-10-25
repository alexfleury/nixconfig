{
  # Import custom packages from the "packages" directory.
  additions = final: _prev: import ../packages { pkgs = final; };

  # Change versions, add patches, set compilation flags, ...
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {

    ankama-launcher = prev.ankama-launcher.overrideAttrs (old: rec {
      src = prev.requireFile {
        name = "Ankama_Launcher-Setup-x86_64.AppImage";
        url = "https://www.dofus.com/fr/mmorpg/telecharger";
        sha256 = "a9bd2550f4acdee4ccc60a04d91b7d0b181ec5f9afd7404bae823c2665dee660";
      };
    });

    #video2x = prev.video2x.override { ffmpeg = prev.ffmpeg-full; };

    # https://github.com/ValveSoftware/gamescope/issues/1622
    #gamescope = prev.gamescope.overrideAttrs (_: {
    #  NIX_CFLAGS_COMPILE = ["-fno-fast-math"];
    #});

    waybar = prev.waybar.overrideAttrs (old: rec {
      version = "0.15.0-unstable";
      doInstallCheck = false;

      buildInputs = (old.buildInputs or []) ++ [
        final.modemmanager
      ];

      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
        final.pkg-config
      ];

      mesonFlags = (old.mesonFlags or []) ++ [
        "-Dcava=disabled"
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
