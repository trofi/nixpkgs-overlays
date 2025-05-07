{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      bison
      gettext
      git
      gnumake
      gperf
      gzip
      help2man
      m4
      python3
      gnutar
      texinfo
      perl
      wget
      xz
    ];
}
