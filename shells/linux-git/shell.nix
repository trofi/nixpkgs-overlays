{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      bc
      bison
      flex
      gnumake

      elfutils
      ncurses
    ];
}
