{ lib
, stdenv
, fetchFromGitHub
, python3
, blktrace
, mplayer
}:

python3.pkgs.buildPythonApplication rec {
  pname = "seekwatcher";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "seekwatcher";
    rev = "v${version}";
    sha256 = "sha256-bz6EGGXQQsS3LQdb7faiJDPtGCNbLAhAh+kk8mNmECs=";
  };

  postPatch = ''
      # embed absolute paths
      substituteInPlace cmd/seekwatcher --replace '"blktrace"' '"${blktrace}/bin/blktrace"'
      substituteInPlace cmd/seekwatcher --replace "'blkparse " "'${blktrace}/bin/blkparse "
      substituteInPlace cmd/seekwatcher --replace '"mencoder ' '"${mplayer}/bin/mencoder '
  '';

  propagatedBuildInputs = with python3.pkgs; [
    cython numpy matplotlib
  ];

  meta = with lib; {
    description = "Graph the results of a blktrace run";
    homepage = "https://github.com/trofi/seekwatcher";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
