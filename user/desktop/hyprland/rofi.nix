{ config, pkgs, ... }:
let
  configPath = ".config/rofi";
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    font = "Fira Sans Nerd Font 12";
    location = "top";
    theme = "~/${configPath}/nord.rasi";
    extraConfig = {
      display-ssh = " ";
      display-run = " ";
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      show-icons = true;
    };
  }; # End of programs.rofi

  home.file = {
    "${configPath}/nord.rasi".text = ''
      * {
        foreground: #${config.palette.foreground0};
        backlight: #${config.palette.foreground2};
        background-color: transparent;
        highlight: underline bold #${config.palette.foreground2};
      }

      window {
        location: center;
        anchor: center;
        transparency: "screenshot";
        padding: 10px;
        border: 0px;
        border-radius: 6px;
        background-color: transparent;
        spacing: 0;
        children: [mainbox];
        orientation: horizontal;
      }

      mainbox {
        spacing: 0;
        children: [ inputbar, message, listview ];
      }

      message {
        color: #${config.palette.black};
        padding: 5;
        border-color: @foreground;
        border:  0px 2px 2px 2px;
        background-color: #${config.palette.accent0};
      }

      inputbar {
        color: #${config.palette.foreground2};
        padding: 11px;
        background-color: #${config.palette.background1};
        border: 1px;
        border-radius:  6px 6px 0px 0px;
        border-color: #${config.palette.accent3};
      }

      entry, prompt, case-indicator {
        text-font: inherit;
        text-color: inherit;
      }

      prompt {
        margin: 0px 1em 0em 0em ;
      }

      listview {
        padding: 8px;
        border-radius: 0px 0px 6px 6px;
        border-color: #${config.palette.accent3};
        border: 0px 1px 1px 1px;
        background-color: #${config.palette.background0};
        dynamic: false;
      }

      element {
        padding: 3px;
        vertical-align: 0.5;
        border-radius: 4px;
        background-color: transparent;
        color: #${config.palette.foreground0};
        text-color: #${config.palette.foreground0};
      }

      element selected.normal {
        background-color: #${config.palette.accent0};
        text-color: #${config.palette.background0};
      }

      element-text, element-icon {
        background-color: inherit;
        text-color: inherit;
      }

      button {
        padding: 6px;
        color: #${config.palette.foreground0};
        horizontal-align: 0.5;
        border: 2px 0px 2px 2px;
        border-radius: 4px 0px 0px 4px;
        border-color: #${config.palette.foreground0};
      }

      button selected normal {
        border: 2px 0px 2px 2px;
        border-color: #${config.palette.foreground0};
      }
    '';
  };
}