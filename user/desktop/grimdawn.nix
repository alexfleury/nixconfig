 { stdenv, lib
, fetchurl
, alsaLib
, openssl
, zlib
, pulseaudio
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "gdstash";
  version = "v180d";

  src = fetchzip {
    url = "https://fmt2.dl.dbolical.com/dl/2016/03/03/GDStash_v180d.zip?st=UCvzi2msj_udC_nT6SFg7Q==&e=1737593564";
    hash = "md5-e6812ef4d3884cee3c2a21e6026207c8";
  };

  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    jdk
    stripJavaArchivesHook
    makeWrapper
  ];

  buildInputs = [
    alsaLib
    openssl
    zlib
    pulseaudio
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D studio-link-standalone-v${version} $out/bin/studio-link
    runHook postInstall

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/foo \
      --add-flags "-cp $out/share/java/foo.jar org.foo.Main"
  '';

  meta = with lib; {
    homepage = "https://studio-link.com";
    description = "Voip transfer";
    platforms = platforms.linux;
  };
}

md5sum = e6812ef4d3884cee3c2a21e6026207c8

curl -L "https://fmt2.dl.dbolical.com/dl/2016/03/03/GDStash_v180d.zip?st=UCvzi2msj_udC_nT6SFg7Q==&e=1737593564" -o "GDStash_v180d.zip"

jdk # Java for GDStash.

https://forums.crateentertainment.com/t/tool-gd-stash/29036