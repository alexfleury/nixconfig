{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.git;
in {
  options.features.cli.git.enable = mkEnableOption "enable git";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user.name = "alexfleury";
        user.email = "28400108+alexfleury@users.noreply.github.com";
        color.ui = true;
        fetch.prune = true;
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
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
      identityFile = "~/.ssh/github";
    };
  };
}