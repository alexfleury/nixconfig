{
  config,
  pkgs,
  ...
}:
let
  user = "tivi";
in rec {
  users.users.${user} = {
    initialHashedPassword = "$y$j9T$jPSbYTUkEYJnvZgIh.3t1.$LGJDpN5OuB9ka6KEogs4DrcBP/tvQBvRA1iO1IWT6RB";
    isNormalUser = true;
    description = user;
    extraGroups = [
    ];
    openssh.authorizedKeys.keys = [
    ];
    shell = pkgs.bash;
  };
  home-manager.users.${user} = import ../../home/${user}/${config.networking.hostName}.nix;
}