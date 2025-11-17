let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/1rKfS9rRiyYjJao5C6s1a+yNIPMjTbfCorl67cZ7u";
in {
  "makemkvKey.age" = {
    publicKeys = [ alex ];
    armor = true;
  };
  "continueEnv.age" = {
    publicKeys = [ alex ];
    armor = true;
  };
}
