{ pkgs ? import <nixpkgs> {} }:
let
  #pythonPkgs = pkgs.python313Packages;
  python = pkgs.python3.withPackages (ps: with ps; [ pygobject3 gst-python ]);
  #hyprshot-gui-python-env = pkgs.python313.buildEnv.override {
  #  extraLibs = with pkgs.python313Packages; [
  #    pygobject3
  #    #gst-python
  #  ];
  #  ignoreCollisions = false;
  #};
  src = pkgs.fetchFromGitHub {
    owner = "s-adi-dev";
    repo = "hyprshot-gui";
    rev = "7cc2d5a01bb73b49182ad5497e0b85bd095e2b97";
    hash = "sha256-ee2aohHpu67jngp0Lrgv0yOhc7d7Ozm0wl/WrjTyhyA=";
  };
in
pkgs.writeShellApplication {
  name = "hyprshot-gui";

  #runtimeInputs = [ pkgs.gtk4 hyprshot-gui-python-env ];
  runtimeInputs = [ pkgs.gtk4 ];

  text = ''
    ${python}/bin/python ${src}/src/hyprshot-gui
  '';
}