{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config
      python3

      gtk4
      libwacom
      libevdev
      lua5_4
      mtdev
      systemd
    ];
}
