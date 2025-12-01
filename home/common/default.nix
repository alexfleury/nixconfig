{
  config,
  inputs,
  outputs,
  ...
}:
{
  # Import home-manager modules (agenix, stylix, and custom ones).
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ]
    ++ builtins.attrValues outputs.homeModules;

  programs.home-manager.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.dates = "weekly";
    clean.extraArgs = "--keep-since 14d --keep 3";
    flake = "${config.home.homeDirectory}/nixconfig";
  };

  home.stateVersion = "24.05"; # Don't change this unless you know.
}