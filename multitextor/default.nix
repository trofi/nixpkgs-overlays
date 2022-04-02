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
  version = "unstable-2022-03-27";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "658c065f391eb82a4d2181787732a04492cac9eb";
    sha256 = "sha256-4oqScZeQgGbkPvrR/yS6vtYVrr+RiJGa24y+xtJyJUg=";
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
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
