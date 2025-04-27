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
  version = "1.5.0-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "fd1d27e233797299d92e12c7b7aa7267484bb6ed";
    hash = "sha256-HhaDpqKXcRgHWSqNA1/oQouOskq9veg26ZyYq0L/J08=";
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
