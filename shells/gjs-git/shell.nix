{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      meson
      ninja
      pkg-config

      cairo
      dbus
      glib
      gobject-introspection
      gtk4
      libsysprof-capture
      readline
      spidermonkey_140
    ];
}
