{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      meson
      pkg-config
      systemd

      liburing
      zstd
    ];
}
