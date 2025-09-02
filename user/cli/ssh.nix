{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."github.com".addKeysToAgent = "yes";
    matchBlocks."github.com".identityFile = "~/.ssh/id_ed25519";
  };
}
