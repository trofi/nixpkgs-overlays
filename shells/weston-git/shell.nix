{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    glslang
    meson
    ninja
    pkg-config
    python3
    wayland-protocols
    wayland-scanner

    aml
    cairo
    fontconfig
    freerdp
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    lcms2
    libdisplay-info
    libdrm
    libevdev
    libgbm
    libglvnd
    libinput
    libjpeg
    libva
    libwebp
    libxcursor
    libxkbcommon
    lua5_4
    neatvnc
    pam
    pango
    pipewire
    pixman
    seatd
    vulkan-loader
    wayland
    xcb-util-cursor
    libxcb
    xwayland
  ];
}
