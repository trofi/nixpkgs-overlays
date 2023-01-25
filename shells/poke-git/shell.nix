{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      gettext
      pkg-config
      texinfo
      help2man
      tcl tcllib tk
      boehmgc
      readline
      json_c
      libnbd
      dejagnu
    ];
}
