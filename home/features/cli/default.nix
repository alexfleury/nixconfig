{
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) filter map toString;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (lib.strings) hasSuffix;
  autoImports = filter (hasSuffix ".nix") (
    map toString (filter (p: p != ./default.nix) (listFilesRecursive ./.))
  );
in {
  imports = autoImports;

  home.shellAliases = {
    ".." = "cd ..";
    sudo = "sudo ";
    mktar = "tar -cvf";
    mkbz2 = "tar -cvjf";
    mkgz = "tar -cvzf";
    untar = "tar -xvf";
    unbz2 = "tar -xvjf";
    ungz = "tar -xvzf";
  };

  home.packages = with pkgs; [
    coreutils # GNU Core Utilities.
    gnutar    # GNU tar utility to archive files/folders.
    rclone    # Rsync but with remote machines.
    tldr      # Utility to get simple examples for CLI tools.
  ];

  programs.bat.enable = true;

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns-preview"
      "--colors=line:style:bold"
      "--hidden"
      "--smart-case"
    ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}