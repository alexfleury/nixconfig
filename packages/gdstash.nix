{
  pkgs
, stdenv ? pkgs.stdenv
, fetchurl ? pkgs.fetchurl
, makeWrapper ? pkgs.makeWrapper
, jre ? pkgs.jre
}:

stdenv.mkDerivation rec {
  pname = "GDStash";
  version = "v181a";

  src = fetchurl {
    url = "https://sjc4.dl.dbolical.com/dl/2016/03/03/GDStash_v181a.zip?st=zbIl4hK5i8p6JwO4miIVKQ==&e=1741571046";
    sha256 = "sha256-zOFME0/fsWTrTCtPC/4IS0gbO47VOGUK6QUQuPnjtnw=";
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