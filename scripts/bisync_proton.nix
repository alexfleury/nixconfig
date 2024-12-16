{ pkgs }:

pkgs.writeShellApplication {
  name = "bisync_proton";

  runtimeInputs = [ pkgs.rclone ];

  text = ''
    rclone bisync protondrive: ~/Data/ProtonDrive --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case
  '';
}