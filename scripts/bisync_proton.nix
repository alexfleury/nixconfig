{ pkgs }:

pkgs.writeShellApplication {
  name = "bisync_proton";

  runtimeInputs = with pkgs; [ rclone ];

  text = ''
    ${pkgs.rclone}/bin/rclone bisync protondrive: ~/Data/ProtonDrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case
  '';
}