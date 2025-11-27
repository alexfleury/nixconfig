{
  config,
  pkgs,
  ...
}:
let
  user = "tivi";
in rec {
  age.secrets = {
    userTiviHashedPasswordFile = {
      file = ../../secrets/userTiviHashedPasswordFile.age;
    };
  };

  users.users.${user} = {
    hashedPasswordFile = config.age.secrets.userTiviHashedPasswordFile.path;
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