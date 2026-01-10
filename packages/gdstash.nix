{
  copyDesktopItems,
  jre,
  makeDesktopItem,
  makeWrapper,
  requireFile,
  stdenv,
  unzip,
}:
let
  description =  "Infinite stash tool for Grim Dawn";
in stdenv.mkDerivation rec {
  pname = "GDStash";
  version = "v181f";

  # GDStash download links expire. Therefore, it should be downloaded
  # beforehand.
  src = requireFile {
    name = "${pname}_${version}.zip";
    url = "https://forums.crateentertainment.com/t/tool-gd-stash/29036";
    sha256 = "e03557ec9589e180004856dc54f3b752decb210d82e1903626004a6a81b2275c";
  };

  dontBuild = true;

  buildInputs = [ unzip makeWrapper copyDesktopItems ];

  unpackPhase = ''
    unzip ${src}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/java $out/bin
    cp GDStash.jar $out/share/java/
    cp -r image $out/share/java/
    cp -r lib $out/share/java/
    cp *.properties $out/share/java/

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/GDStash.jar" \
      --chdir $out/share/java

    runHook postInstall
  '';

  desktopItems =  [
    (makeDesktopItem {
      name = "gdstash";
      desktopName = "GDStash";
      comment = description;
      exec = "GDStash";
      icon = "games-app-symbolic";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    })
  ];

  meta = {
    inherit description;
    homepage = "https://forums.crateentertainment.com/t/tool-gd-stash/29036";
  };
}