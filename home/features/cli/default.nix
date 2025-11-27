{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./borgmatic.nix
    ./fastfetch.nix
    ./git.nix
    ./python.nix
    ./ssh.nix
    ./starship.nix
  ];

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