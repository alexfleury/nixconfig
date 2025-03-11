{
  pkgs
, copyDesktopItems ? pkgs.jre
, jre ? pkgs.jre
, makeDesktopItem ? pkgs.makeWrapper
, makeWrapper ? pkgs.makeWrapper
, requireFile ? pkgs.requireFile
, stdenv ? pkgs.stdenv
}:
let
  description =  "Infinite stash tool for Grim Dawn";
in
stdenv.mkDerivation rec {
  pname = "GDStash";
  version = "v181a";

  # GDStash download links expire. Therefore, it should be downloaded
  # beforehand.
  src = requireFile {
    name = "${pname}_${version}.zip";
    url = "https://forums.crateentertainment.com/t/tool-gd-stash/29036";
    sha256 = "zOFME0/fsWTrTCtPC/4IS0gbO47VOGUK6QUQuPnjtnw=";
  };

  dontBuild = true;

  nativeBuildInputs = [ pkgs.unzip makeWrapper copyDesktopItems ];

  unpackPhase = ''
    unzip ${src}
  '';

  desktopItems =  [
    (makeDesktopItem {
      name = "gdstash";
      desktopName = "GDStash";
      comment = description;
      exec = "GDStash";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
    })
  ];

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

  meta = {
    inherit description;
    homepage = "https://forums.crateentertainment.com/t/tool-gd-stash/29036";
  };
}