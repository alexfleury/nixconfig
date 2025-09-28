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
        "[](#3B4252)"
        "$nix_shell"
        "$python"
        "$username"
        "[](bg:#434C5E fg:#3B4252)"
        "$directory"
        "[](fg:#434C5E bg:#4C566A)"
        "$git_branch"
        "$git_status"
        "[](fg:#4C566A bg:#86BBD8)"
        "$c"
        "$julia"
        "$rust"
        "[](fg:#86BBD8 bg:#06969A)"
        "$docker_context"
        "[](fg:#06969A bg:#33658A)"
        "$time"
        "[ ](fg:#33658A)"
      ];
      add_newline = false;
      command_timeout = 5000;

      username = {
        show_always = true;
        style_user = "bg:#3B4252";
        style_root = "bg:#3B4252";
        format = "[$user ]($style)";
      };

      directory = {
        style = "bg:#434C5E";
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
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      docker_context = {
        symbol = " ";
        style = "bg:#06969A";
        format = "[ $symbol $context ]($style)$path";
      };

      git_branch = {
        symbol = "";
        style = "bg:#4C566A";
        format = "[ $symbol $branch ]($style)";
      };

      git_status = {
        style = "bg:#4C566A";
        format = "[$all_status$ahead_behind ]($style)";
      };

      julia = {
        symbol = " ";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      # TODO
      #nix_shell = {
      #  style = "bg:#3B4252";
      #  format = "[(\($virtualenv\) )]($style)";
      #};

      python = {
        style = "bg:#3B4252";
        format = "[(\($virtualenv\) )]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:#86BBD8";
        format = "[ $symbol ($version) ]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R"; # Hour:Minute Format
        style = "bg:#33658A";
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
