{ config, ... }: {
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/agenix" ];
    secrets = {
      makemkvKey = {
        file = ../../secrets/makemkvKey.age;
      };
      continueEnv = {
        file = ../../secrets/continueEnv.age;
        path = "${config.home.homeDirectory}/.continue/.env";
      };
      noctaliaCalendarTOML = {
        file = ../../secrets/noctaliaCalendarTOML.age;
        path = "${config.home.homeDirectory}/.config/noctalia/calendar.toml";
      };
    };
  };
}