{
  config,
  pkgs,
  ...
}:
let
  user = "alex";
in {
  users.users.${user} = {
    initialHashedPassword = "$y$j9T$EApohmRLzp9rj3vi1m.zw.$hUEW49/rb9xBFUzxouNID5pSSL5zE8bIXPahCuBGJM6";
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