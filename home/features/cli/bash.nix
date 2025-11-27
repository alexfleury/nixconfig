{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.cli.bash;
in {
  options.features.cli.bash.enable = mkEnableOption "enable extended bash configuration";

  config = mkIf cfg.enable {
    #https://github.com/basecamp/omarchy/blob/master/default/bash/functions
    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyControl = [
        "ignoreboth"
        "erasedups"
      ];
      historyIgnore = [
        "ls"
        "cd"
        "exit"
      ];
      shellOptions = [
        "histappend"
        "checkwinsize"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      bashrcExtra = lib.concatLines [
        "HISTTIMEFORMAT=\"%F %T\""
      ];
      initExtra = ''
        # Transcode a video to a good-balance 1080p that's great for sharing online.
        transcode-video-1080p() {
          ${pkgs.ffmpeg}/bin/ffmpeg -i $1 -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy ''${1%.*}-1080p.mp4
        }

        # Transcode a video to a good-balance 4K that's great for sharing online.
        transcode-video-4K() {
          ${pkgs.ffmpeg}/bin/ffmpeg -i $1 -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k ''${1%.*}-optimized.mp4
        }

        # Transcode any image to JPG image that's great for shrinking wallpapers.
        img2jpg() {
          ${pkgs.imagemagick}/bin/magick $1 -quality 95 -strip ''${1%.*}.jpg
        }

        # Transcode any image to JPG image that's great for sharing online without being too big.
        img2jpg-small() {
          ${pkgs.imagemagick}/bin/magick $1 -resize 1080x\> -quality 95 -strip ''${1%.*}.jpg
        }

        # Transcode any image to compressed-but-lossless PNG.
        img2png() {
          ${pkgs.imagemagick}/bin/magick "$1" -strip -define png:compression-filter=5 \
            -define png:compression-level=9 \
            -define png:compression-strategy=1 \
            -define png:exclude-chunk=all \
            "''${1%.*}.png"
        }
      '';
    };
  };
}