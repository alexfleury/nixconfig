{ pkgs }:

# nix-build -E 'let pkgs = import <nixpkgs> { }; in pkgs.callPackage ./progress_bar.nix {}'
pkgs.writeShellApplication {
  name = "progress_bar";
  runtimeInputs = with pkgs; [ bashNonInteractive ];
  text = builtins.readFile ./bash/progress_bar.sh;
}