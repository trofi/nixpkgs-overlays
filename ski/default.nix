{ lib
, stdenv
, fetchFromGitHub

, autoconf
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
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "unstable-2022-08-19";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "9bdd82db79183bf4d168cbe7874c3b37d2baf019";
    sha256 = "sha256-5d0RwglhJT4hJel7YvUHXxajNxm9W7fIJYpZ2CW5ApI=";
  };

  postPatch = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
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

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package ski --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/trofi/ski.git";
  };

  meta = with lib; {
    description = "ia64 (Itanium) instruction set simulator.";
    homepage = "https://github.com/trofi/ski";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
