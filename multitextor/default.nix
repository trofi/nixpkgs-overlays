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
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "276393f81c4302bb586c63a764a1dc21e6529284";
    sha256 = "sha256-/JHJ5EQDguRvZ2v+uvK7V67ammuA/DpgsbUNhC/EqzE=";
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
