{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "ssh" "safe-paste" ];
      theme = "agnoster";
    };
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
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
