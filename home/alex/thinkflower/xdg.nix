{
  ...
}:
{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
    mimeApps.defaultApplications = {
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "image/*" = [ "nomacs.desktop" ];
      "video/*" = [ "vlc.desktop" ];
      "audio/*" = [ "vlc.desktop" ];
      "inode/directory" = [ "thunar.desktop" ];
      "text/plain" = [ "org.gnome.TextEditor.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
    userDirs.enable = true;
    userDirs.createDirectories = true;
    userDirs.setSessionVariables = true;
  };
}
