{ lib
, stdenv
, fetchgit
, perl
, groff
, mandoc
}:

stdenv.mkDerivation rec {
  pname = "checkpatch";
  version = "unstable-2022-02-08";

  src = fetchgit {
    url = "git://www.alejandro-colomar.es/src/alx/linux/checkpatch.git";
    rev = "812b311a93ff96a20ab6573e330704d176b87e88";
    sha256 = "sha256-zJDvPXiYLSaNH/i4uVWa0PjcOkADLXe/slMDgIqDzRs=";
  };
  patches = [ ./0001-checkpatch.1-uppercase-.TH-tool-name.patch ];

  postPatch = ''
    substituteInPlace bin/checkpatch --replace '/usr/bin/env perl' "${perl}/bin/perl"
    substituteInPlace share/man/man1/checkpatch.1 --replace '.MR' '.BR'
  '';

  makeFlagsArray = [ "prefix=${placeholder "out"}" ];

  nativeBuildInputs = [
    groff
    mandoc
  ];

  meta = with lib; {
    description = "Graph the results of a blktrace run";
    homepage = "http://www.alejandro-colomar.es/src/alx/linux/checkpatch.git/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
