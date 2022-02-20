{ lib
, stdenv
, fetchgit
, checkpatch
, coreutils
, include-what-you-use
, clang-tools
, cppcheck
, cpplint
, groff
, mandoc
}:

stdenv.mkDerivation rec {
  pname = "chessutils";
  version = "unstable-2022-02-07";

  src = fetchgit {
    url = "git://www.alejandro-colomar.es/src/alx/alx/games/chessutils.git";
    rev = "bb804a6127e4e1f1000a8269b7b9d8a4ce73fa25";
    sha256 = "sha256-/+7CpLhBsWWKy4xT0O99ypWVeGVJQi4AKFDxa6/OLDk=";
  };

  patches = [
    ./0001-Makefile-use-usr-bin-env-bash-instead-of-bin-bash.patch
    ./0001-Makefile-use-include-what-you-use-not-iwyu-binary-na.patch
  ];
  postPatch = ''
    for m in share/man/*/*.*; do
      substituteInPlace $m --replace '.MR' '.BR'
    done
  '';

  makeFlags = [
    "prefix=${placeholder "out"}"
    # Does on work as is on nixpkgs, fails to find stdlib.
    "IWYU=${coreutils}/bin/true"
  ];

  nativeBuildInputs = [
    checkpatch
    # for clang-tidy
    clang-tools
    cppcheck
    cpplint
    include-what-you-use
    groff
    mandoc
  ];

  meta = with lib; {
    description = "Graph the results of a blktrace run";
    homepage = "http://www.alejandro-colomar.es/src/alx/alx/games/chessutils.git";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
