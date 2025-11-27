{
  lib,
  pkgs,
  ...
}:
let
  user = "tivi";
in {
  imports = [
    ../common
    ../features/cli
    ../features/desktop
  ];

  home.username = user;
  home.homeDirectory = "/home/${user}";

  home.packages = with pkgs; [
    brave            # Brave web browser.
    protonvpn-gui    # Proton VPN.
    vlc              # Reading videos.
  ];

  # Programs with options.
  programs.freetube.enable = true;
  programs.yt-dlp.enable = true;
  programs.brave.nativeMessagingHosts = [
    pkgs.kdePackages.plasma-browser-integration
  ];

}