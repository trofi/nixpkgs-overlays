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
  version = "unstable-2022-03-09";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "8b2df7f138293af6a59b7fe0dae854969aacd0c9";
    sha256 = "sha256-eEsZAHR6J6YPQxgcvfX4VmEAeBodNNMlZf/GoOtHBlY=";
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
