{ ... }:

{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
  }; # End of programs.zsh.

  programs.bat.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  }; # End of programs.fzf.

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  }; # End of programs.zoxide.
}
