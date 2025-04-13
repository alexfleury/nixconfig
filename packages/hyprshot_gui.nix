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
    rev = "7cc2d5a01bb73b49182ad5497e0b85bd095e2b97";
    hash = "sha256-ee2aohHpu67jngp0Lrgv0yOhc7d7Ozm0wl/WrjTyhyA=";
  };

  nativeBuildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  propagatedBuildInputs = with pkgs; [
    (python3.withPackages (ps: with ps; [
      pygobject3
    ]))
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