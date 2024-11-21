{ ... }:

{
  programs.git = {
    enable = true;
    userName = "alexfleury";
    userEmail = "28400108+alexfleury@users.noreply.github.com";
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

      # Per repo gitignore.
      ".gitignore"

      # Data files.
      "*.hdf5"

      # VS Code workspace files.
      ".vscode"
      "*.code-workspace"
    ];
    extraConfig = {
      color.ui = true;
      fetch.prune = true;
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  }; # End of programs.git.
}