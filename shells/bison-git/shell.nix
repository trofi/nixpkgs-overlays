{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      flex
      gettext
      gperf
      graphviz
      gzip
      help2man
      perl
      rsync
      gnutar
      texinfo
      valgrind
    ];
}
