{ lib
, stdenv
, fetchFromGitHub

, autoconf
, autoconf-archive
, automake
, bison
, flex
, gperf
, libtool
, pkg-config

, elfutils
, libbfd
, libiberty
, ncurses

, unstableGitUpdater
, ski
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "1.5.0-unstable-2025-08-15";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "236f60f5130046a7d7633a33e6ca39f58625881f";
    hash = "sha256-aKIs784Kmmqvwrdo8jV8u2NTJWwrxcO3DzZw8cIsla4=";
  };

  postPatch = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    bison
    flex
    gperf
    libtool
    pkg-config
  ];

  buildInputs = [
    elfutils
    libbfd
    libiberty
    ncurses
  ];

  makeFlags = [
    "appdefaultsdir=${placeholder "out"}/etc/X11/app-defaults"
  ];

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package ski --arg include-overlays true
  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
      url = "https://github.com/trofi/ski.git";
    };
  };

  meta = with lib; {
    description = "ia64 (Itanium) instruction set simulator.";
    homepage = "https://github.com/trofi/ski";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
