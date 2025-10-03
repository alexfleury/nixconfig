{
  pkgs
, wrapGAppsHook4 ? pkgs.wrapGAppsHook4
, gobject-introspection ? pkgs.gobject-introspection
}:
let
  description =  "A simple GTK4-based application for taking screenshots, utilizing HyprShot under the hood. The design is inspired by GNOME Screenshot.";
in
pkgs.python3Packages.buildPythonApplication rec {
  pname = "hyprshot-gui";
  version = "0.1.0";
  pyproject = false;

  src = pkgs.fetchFromGitHub {
    owner = "s-adi-dev";
    repo = "hyprshot-gui";
    rev = "5d210997ae44dbb9b4f88294a07d05945ee0a785";
    hash = "sha256-Sbl4O/mVPP1kCjwS/MF2TYdKd/3dUKHvscsffiOqC2o=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  propagatedBuildInputs = with pkgs; [
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
    hyprshot
  ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 "$src/src/${pname}" "$out/bin/${pname}"
  '';

  meta = {
    inherit description;
    homepage = "https://github.com/s-adi-dev/hyprshot-gui/tree/main";
  };
}