{ config, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    location = "center";
    extraConfig = {
      display-ssh = " ";
      display-run = " ";
      display-drun = " ";
      display-window = " ";
      display-combi = " ";
      show-icons = true;
    };

    theme = {
      window = {
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        padding = mkLiteral "10px";
        border = mkLiteral "0px";
        border-radius = mkLiteral "6px";
        spacing = mkLiteral "0";
        children = mkLiteral "[mainbox]";
        orientation = mkLiteral "horizontal";
      };

      mainbox = {
        spacing = mkLiteral "0";
        children = mkLiteral "[ inputbar, message, listview ]";
      };

      message = {
        padding = mkLiteral "5";
        border = mkLiteral "0px 2px 2px 2px";
      };

      inputbar = {
        padding = mkLiteral "11px";
        border = mkLiteral "1px";
        border-radius = mkLiteral "6px 6px 0px 0px";
      };

      prompt = {
        margin = mkLiteral "0px 1em 0em 0em";
      };

      listview = {
        padding = mkLiteral "8px";
        border-radius = mkLiteral "0px 0px 6px 6px";
        border = mkLiteral "0px 1px 1px 1px";
        dynamic = mkLiteral "false";
      };

      element = {
        padding = mkLiteral "3px";
        vertical-align = mkLiteral "0.5";
        border-radius = mkLiteral "4px";
      };

      button = {
        padding = mkLiteral "6px";
        horizontal-align = mkLiteral "0.5";
        border = mkLiteral "2px 0px 2px 2px";
        border-radius = mkLiteral "4px 0px 0px 4px";
      };

      "button selected normal" = {
        border = mkLiteral "2px 0px 2px 2px";
      };
    };
  };
}