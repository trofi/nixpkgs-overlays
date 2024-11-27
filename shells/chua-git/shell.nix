{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    freeglut
    libglvnd
    mesa_glu
    meson
    ninja
    pkg-config
  ];
}
