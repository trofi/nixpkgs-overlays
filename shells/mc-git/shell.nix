{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      gettext
      libtool
      gnumake
      glib
      slang
      openssl
      libssh2
      libx11
      gpm
      file
      pkg-config
      perl
    ];
  }
