{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      pkg-config
      autoreconfHook
      unzip

      file
      gettext
      glib
      perl
      slang
      zip
    ];
}
