{ ... }:

{
  programs.ssh = {
    enable = true;
    # Will be removed in the future.
    enableDefaultConfig = false;

    matchBlocks = {
      # Default config.
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };

      "pihole" = {
        hostname = "192.168.0.14";
        user = "alexandre";
        port= 22;
      };
    };
  };
}
