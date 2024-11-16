{ config, pkgs, ... }:
let
  c = config.palette;
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
        foreground: #${c.foreground0};
        backlight: #${c.foreground2};
        background-color: transparent;
        highlight: underline bold #${c.foreground2};
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
        color: #${c.black};
        padding: 5;
        border-color: @foreground;
        border:  0px 2px 2px 2px;
        background-color: #${c.accent0};
      }

      inputbar {
        color: #${c.foreground2};
        padding: 11px;
        background-color: #${c.background1};
        border: 1px;
        border-radius:  6px 6px 0px 0px;
        border-color: #${c.accent3};
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
        border-color: #${c.accent3};
        border: 0px 1px 1px 1px;
        background-color: #${c.background0};
        dynamic: false;
      }

      element {
        padding: 3px;
        vertical-align: 0.5;
        border-radius: 4px;
        background-color: transparent;
        color: #${c.foreground0};
        text-color: #${c.foreground0};
      }

      element selected.normal {
        background-color: #${c.accent0};
        text-color: #${c.background0};
      }

      element-text, element-icon {
        background-color: inherit;
        text-color: inherit;
      }

      button {
        padding: 6px;
        color: #${c.foreground0};
        horizontal-align: 0.5;
        border: 2px 0px 2px 2px;
        border-radius: 4px 0px 0px 4px;
        border-color: #${c.foreground0};
      }

      button selected normal {
        border: 2px 0px 2px 2px;
        border-color: #${c.foreground0};
      }
    '';
   # "${configPath}/wifimenu.rasi"
  };

}