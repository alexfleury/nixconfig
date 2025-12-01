{ pkgs, ... }: {
  imports = [
    ./gaming.nix
    ./ollama.nix
    ./openrgb.nix
    ./printing.nix
    ./qmk.nix
    ./thunar.nix
    ./vms.nix
  ];

  environment.systemPackages = with pkgs; [
    dysk          # Get (pretty) info about mounted disks.
    e2fsprogs     # Ext2 utilities.
    exfat         # exFat support.
    exfatprogs    # exFat utilities.
    gptfdisk      # Better tool for partionning disks.
    psmisc        # For fuse and proc file systems.
    unzip         # Unzipping archives.
    vim           # Vim editor.
    wget          # Download in CLI.
  ];
}