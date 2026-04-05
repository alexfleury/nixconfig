{
  lib,
  pkgs,
  ...
}:
let
  user = "isa";
in {
  imports = [ ../common ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.packages = with pkgs; [
    brave
    discord
    libreoffice
    obsidian
    proton-vpn
    vlc
  ];

  # Programs with options.
  programs.brave.nativeMessagingHosts = [
    pkgs.kdePackages.plasma-browser-integration
  ];

}