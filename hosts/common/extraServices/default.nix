{ pkgs, ... }: {
  imports = [
    ./gaming.nix
    ./ollama.nix
    ./openrgb.nix
    ./printing.nix
    ./qmk.nix
    ./stylix.nix
    ./thunar.nix
    ./vms.nix
  ];

  environment.systemPackages = with pkgs; [
    # Get (pretty) info about mounted disks.
    dysk
    e2fsprogs
    exfat
    exfatprogs
    gptfdisk
    psmisc
    unzip
    vim
    wget
  ];
}