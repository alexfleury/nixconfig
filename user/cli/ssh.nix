{ ... }:

{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks."github.com".identityFile = "~/.ssh/id_ed25519";
  };
}

#Host *
#    IgnoreUnknown UseKeychain
#
#Host github.com
#    UseKeychain yes
#    IdentityFile ~/.ssh/id_ed25519
#
#Host pihole
#    HostName 192.168.0.14
#    User alexandre
