{
  config,
  pkgs,
  ...
}:
let
  user = "alex";
in rec {

  users.users.${user} = {
    initialHashedPassword = "$y$j9T$OYVCw/PECtBF1I0KlvGBD.$uB/rADJJKp6181pZZU6bwimd/Dx9.WQQQRhCGkdR7p7";
    isNormalUser = true;
    description = user;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      # Agenix
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/1rKfS9rRiyYjJao5C6s1a+yNIPMjTbfCorl67cZ7u alex@quantumflower"
      # Github key.
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKidPxqmVSowhYJNuPnD+yI81SIib4HLR+JDSfxjpV22 alex@quantumflower"
    ];
    shell = pkgs.bash;
  };
  home-manager.users.${user} = import ../../../home/${user}/${config.networking.hostName}.nix;
}