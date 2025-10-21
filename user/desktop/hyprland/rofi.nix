{ config, pkgs, lib, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    location = "center";
    extraConfig = {
      display-calc = " Calculator";
      display-drun = " Apps";
      display-recursivebrowser = " Files";
      #display-run = " Run";
      display-top = " Top";
      display-window = " Window";
      modi = "drun,recursivebrowser,calc,top";
      run-command = "uwsm app -- {cmd}";
      show-icons = true;
      click-to-exit = true;
    };
    modes = [
      "calc"
      "drun"
      "recursivebrowser"
      "top"
      "window"
      {
        name = "whatnot";
        path = lib.getExe (import ./search_nixpkgs.nix { inherit pkgs; } );
      }
      {
        name = "whatnot";
        path = lib.getExe (import ./search_mynixos { inherit pkgs; } );
      }
    ];
    plugins = with pkgs; [
      rofi-calc
      rofi-top
    ];

    theme = {
      window = {
        anchor = mkLiteral "center";
        border = mkLiteral "0px";
        border-radius = mkLiteral "6px";
        children = mkLiteral "[mainbox]";
        location = mkLiteral "center";
        orientation = mkLiteral "horizontal";
        padding = mkLiteral "10px";
        spacing = mkLiteral "0";
        width = mkLiteral "30%";
      };

      mainbox = {
        children = mkLiteral "[ \"inputbar\", \"message\", \"listview\", \"mode-switcher\" ]";
        spacing = mkLiteral "0";
      };

      message = {
        border = mkLiteral "0px 2px 2px 2px";
        padding = mkLiteral "5";
      };

      inputbar = {
        border = mkLiteral "1px";
        border-radius = mkLiteral "6px 6px 0px 0px";
        padding = mkLiteral "11px";
      };

      prompt = {
        margin = mkLiteral "0px 1em 0em 0em";
      };

      listview = {
        border-radius = mkLiteral "0px 0px 6px 6px";
        border = mkLiteral "0px 1px 1px 1px";
        dynamic = mkLiteral "false";
        padding = mkLiteral "8px";
      };

      element = {
        border-radius = mkLiteral "4px";
        padding = mkLiteral "3px";
        vertical-align = mkLiteral "0.5";
      };

      mode-switcher = {
        border = mkLiteral "0px solid";
        border-radius = mkLiteral" 0px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        spacing = mkLiteral "10px";
      };

      button = {
        border = mkLiteral "0 px solid";
        border-radius = mkLiteral "20px";
        cursor = mkLiteral "pointer";
        padding = mkLiteral "5px 10px";
      };
    };
  };
}