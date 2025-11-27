{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.git;
  sshFolder = "${config.home.homeDirectory}/.ssh";
  sshPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKidPxqmVSowhYJNuPnD+yI81SIib4HLR+JDSfxjpV22 alex@quantumflower";
in {
  options.features.cli.git.enable = mkEnableOption "enable git";

  config = mkIf cfg.enable rec {
    programs.git = {
      enable = true;
      lfs.enable = true;

      settings = {
        user.name = "alexfleury";
        user.email = "28400108+alexfleury@users.noreply.github.com";
        user.signingkey = "${sshFolder}/github.pub";
        color.ui = true;
        fetch.prune = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
        commit.gpgsign = true;
        gpg.ssh.allowedSignersFile = "${sshFolder}/allowed_signers";
      };

      ignores = [
        # MacOS junk.
        ".DS_store"
        # Python compilation and cache.
        "*.pyc"
        "build"
        "dist"
        ".eggs"
        "*.egg-info"
        "__pycache__"
        ".ipynb_checkpoints"
        # Data files.
        "*.hdf5"
        # VS Code workspace files.
        ".vscode"
        "*.code-workspace"
      ];
    };

    programs.ssh.matchBlocks."github.com" = {
      addKeysToAgent = "yes";
      identityFile = "${sshFolder}/github";
    };

    home.file."allowed_signers" = {
      target = ".ssh/allowed_signers";
      text = "${config.programs.git.settings.user.email} namespaces=\"git\" ${sshPublicKey}";
    };
  };
}