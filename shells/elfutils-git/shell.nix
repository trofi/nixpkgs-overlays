{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      bison
      flex
      gettext
      pkg-config-unwrapped
      pkg-config

      bzip2
      curl
      json_c
      libarchive
      libmicrohttpd
      sqlite
      zlib
      zstd
      xz
    ];
}
