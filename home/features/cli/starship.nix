{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.features.cli.starship;
in {
  options.features.cli.starship.enable = mkEnableOption "enable starship configuration";

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableBashIntegration = true;
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
          "$time"
          "[ ](fg:red)"
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
          style = "bg:blue fg:base00";
          truncation_length = 10;
          format = "[ $symbol $branch ]($style)";
        };

        git_status = {
          style = "bg:blue fg:bold base00";
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
          style = "bg:red fg:base00";
          format = "[ $time ]($style)";
        };

      };
    };
  };
}