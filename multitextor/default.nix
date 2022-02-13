{ lib
, stdenv
, fetchFromGitHub
, cmake
, gpm
, ncurses

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "multitextor";
  version = "unstable-2022-02-09";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "e8cc2b70afd934370e5dad306fb78809ac6f9651";
    sha256 = "sha256-4qcp5YqFIqS2FNssP28izfZ1QGQWw1ABaRQAW3NFxIo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gpm
    ncurses
  ];

  enableParallelBuilding = true;

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package multitextor --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vikonix/multitextor";
  };

  meta = with lib; {
    description = "Multiplatform command line text editor.";
    homepage = "https://github.com/vikonix/multitextor";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
