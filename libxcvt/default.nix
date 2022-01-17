{ lib
, stdenv
, fetchurl
, meson
, ninja
}:

stdenv.mkDerivation rec {
  pname = "libxcvt";
  version = "0.1.1";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/lib/libxcvt-${version}.tar.xz";
    sha256 = "sha256-J+vOGA01X5TBmSkwvttAo29tcxLuUL9/CsvNIvM+jCk=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = with lib; {
    description = "VESA CVT standard timing modelines generator";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcvt/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
