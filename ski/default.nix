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
  version = "1.5.1-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "b7d8cf356bbb5de03680f32cc5555d4d80afa7f8";
    hash = "sha256-Wh1rEcQOJkz/MWKPi4bUrqqbkYTSTL3h/1ILj1wBCnM=";
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
