let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/1rKfS9rRiyYjJao5C6s1a+yNIPMjTbfCorl67cZ7u";
  quantumflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJpTLB9uuwn94JIoQGyH7C4MPJLoe7vEvqVirQZyjOi";
  tvflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPCC9ow6Psotpo7dP+d9Swe4S0PNrRhJLTL4pwB8Ldc";
in {
  "makemkvKey.age" = {
    publicKeys = [ alex ];
    armor = true;
  };
  "continueEnv.age" = {
    publicKeys = [ alex ];
    armor = true;
  };
  "userAlexHashedPasswordFile.age" = {
    publicKeys = [ quantumflower tvflower ];
    armor = true;
  };
  "userTiviHashedPasswordFile.age" = {
    publicKeys = [ quantumflower tvflower ];
    armor = true;
  };
}
