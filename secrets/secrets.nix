let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM/1rKfS9rRiyYjJao5C6s1a+yNIPMjTbfCorl67cZ7u";
  users = [ alex ];
  quantumflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPJpTLB9uuwn94JIoQGyH7C4MPJLoe7vEvqVirQZyjOi";
  thinkflower = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDlK7I8Cp3V1tzHYsM7YCNrYE+1cshBRwxizVa2YKgFD";
  systems = [ quantumflower thinkflower ];
in {
  "makemkvKey.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
  "continueEnv.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
  "noctaliaCalendarTOML.age" = {
    publicKeys = users ++ systems;
    armor = true;
  };
}
