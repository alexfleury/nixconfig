{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = true;

    matchBlocks."pihole" = {
      hostname = "192.168.0.14";
      user = "alexandre";
      port= 22;
    };
  };
}
