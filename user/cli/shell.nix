{ pkgs, lib, ... }:
{
  #https://github.com/basecamp/omarchy/blob/master/default/bash/functions
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];
    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    bashrcExtra = lib.concatLines [
      "HISTTIMEFORMAT=\"%F %T\""
    ];
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableInteractive = true;
    settings = {
      format = lib.concatStrings [
        "[](base01)"
        "$nix_shell"
        "$python"
        "$username"
        "[](bg:base03 fg:base01)"
        "$directory"
        "[](fg:base03 bg:blue)"
        "$git_branch"
        "$git_status"
        "[](fg:blue bg:green)"
        "$c"
        "$julia"
        "$rust"
        "[](fg:green bg:red)"
        "$docker_context"
        "[](fg:red bg:brown)"
        "$time"
        "[ ](fg:brown)"
      ];
      add_newline = true;
      command_timeout = 5000;

      username = {
        show_always = true;
        style_user = "bg:base01 fg:white";
        style_root = "bg:base01 fg:white";
        format = "[$user ]($style)";
      };

      directory = {
        style = "bg:base03 fg:white";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      c = {
        symbol = " ";
        style = "bg:green fg:white";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:red fg:white";
        format = "[ $symbol $context ]($style)$path";
      };

      git_branch = {
        symbol = "";
        style = "bg:blue fg:white";
        truncation_length = 10;
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:blue fg:bold white";
        format = "[$all_status$ahead_behind ]($style)";
      };

      julia = {
        symbol = " ";
        style = "bg:green fg:white";
        format = "[ $symbol ($version) ]($style)";
      };

      nix_shell = {
        style = "bg:base01 fg:white";
      };

      python = {
        symbol = "";
        style = "bg:base01 fg:white";
        format = "[(\($virtualenv\) )]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:green fg:white";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%kh%Mm%Ss";
        style = "bg:brown fg:white";
        format = "[ $time ]($style)";
      };

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
    enableBashIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };
}
