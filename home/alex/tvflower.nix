{ pkgs, ... }:
let
  user = "alex";
in {
  imports = [
    ../common
    ../features/cli
    ../features/desktop
  ];

  features.cli.bash.enable = true;

  home.username = user;
  home.homeDirectory = "/home/${user}";

}