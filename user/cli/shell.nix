{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = ''
      if [ "`id -u`" -eq 0 ]; then
          PS1="[ \[\e[1;31m\]λ\[\e[1;32m\]\[\e[49m\] \W \[\e[0m\]] "
      else
          PS1="[ \[\e[1;32m\]λ \W \[\e[0m\]] "
      fi
    '';
  };

  programs.bat.enable = true;

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--max-columns-preview"
      "--colors=line:style:bold"
      "--hidden"
      "--smart-case"
    ];
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}
