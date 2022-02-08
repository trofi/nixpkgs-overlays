{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, gpm
, ncurses

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "multitextor";
  version = "unstable-2022-02-04";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "90b6877cc08bb7c6a660fe361b641b3941c84cbd";
    sha256 = "sha256-rlB48b7ebLbpG/lLALwtMw50Mlfn7CocMZG8i9QnA0c=";
  };

  patches = [
    # https://github.com/vikonix/multitextor/pull/21
    (fetchpatch {
      name = "obey-prefix.patch";
      url = "https://github.com/vikonix/multitextor/commit/09c390173fc4e1e15d0073652120edc59fe1051b.patch";
      sha256 = "sha256-Qr6AAGCaKWAmkqeB2w6N1HHga5FhEB3ZhdM4UBi7IdE=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gpm
    ncurses
  ];

  enableParallelBuilding = true;

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package multitextor --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "sha256-rlB48b7ebLbpG/lLALwtMw50Mlfn7CocMZG8i9QnA0c=";
  };

  meta = with lib; {
    description = "Multiplatform command line text editor.";
    homepage = "https://github.com/vikonix/multitextor";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
