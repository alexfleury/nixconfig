{
  fetchFromGitHub,
  gobject-introspection,
  hyprshot,
  python3Packages,
  wrapGAppsHook4,
}:
let
  description =  "A simple GTK4-based application for taking screenshots, utilizing HyprShot under the hood. The design is inspired by GNOME Screenshot.";
in python3Packages.buildPythonApplication rec {
  pname = "hyprshot-gui";
  version = "0.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "s-adi-dev";
    repo = "hyprshot-gui";
    rev = "5d210997ae44dbb9b4f88294a07d05945ee0a785";
    hash = "sha256-Sbl4O/mVPP1kCjwS/MF2TYdKd/3dUKHvscsffiOqC2o=";
  };

  buildInputs = [
    wrapGAppsHook4
    gobject-introspection
  ];

  propagatedBuildInputs = [
    hyprshot
    python3Packages.pygobject3
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 "$src/src/${pname}" "$out/bin/${pname}"
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    inherit description;
    homepage = "https://github.com/s-adi-dev/hyprshot-gui/tree/main";
    mainProgram = pname;
  };
}