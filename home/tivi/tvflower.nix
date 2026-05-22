{
  lib,
  pkgs,
  ...
}:
let
  user = "tivi";
in {
  imports = [ ../common ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.packages = with pkgs; [
    brave
    #proton-vpn
    vlc
  ];

  # Programs with options.
  programs.freetube.enable = true;
  programs.yt-dlp.enable = true;
  programs.brave.nativeMessagingHosts = [
    pkgs.kdePackages.plasma-browser-integration
  ];

}