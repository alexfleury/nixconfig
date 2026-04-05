{
  config,
  pkgs,
  ...
}:
{
  users.users."tivi" = {
    initialHashedPassword = "$y$j9T$jPSbYTUkEYJnvZgIh.3t1.$LGJDpN5OuB9ka6KEogs4DrcBP/tvQBvRA1iO1IWT6RB";
    isNormalUser = true;
    description = "tivi";
    shell = pkgs.bash;
  };
  home-manager.users."tivi" = import ../../home/tivi/${config.networking.hostName}.nix;

  users.users."isa" = {
    initialHashedPassword = "$y$j9T$yaeLWaWmyDFlDBaoRIKs7/$YSIF85z.QWPg8Fz8mKhnrcWPko9V/PpCljPy.MP.Br5";
    isNormalUser = true;
    description = "isa";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.bash;
  };
  home-manager.users."isa" = import ../../home/isa/${config.networking.hostName}.nix;
}