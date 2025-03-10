{
  pkgs
, stdenv ? pkgs.stdenv
, requireFile ? pkgs.requireFile
, makeWrapper ? pkgs.makeWrapper
, jre ? pkgs.jre
}:

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

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = ''
    ${pkgs.unzip}/bin/unzip ${src}
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp GDStash.jar $out/share/java/
    cp -r image $out/share/java/
    cp -r lib $out/share/java/
    cp *.properties $out/share/java/

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/GDStash.jar" \
      --chdir $out/share/java
  '';

  meta = {
    homepage = "https://forums.crateentertainment.com/t/tool-gd-stash/29036";
    description = "Infinite stash tool for Grim Dawn.";
  };
}