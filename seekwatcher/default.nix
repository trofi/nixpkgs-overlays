{ lib
, stdenv
, fetchFromGitHub
, python3
, blktrace
, ffmpeg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "seekwatcher";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "seekwatcher";
    rev = "v${version}";
    hash = "sha256-If++XxuenLCXxnG7C7YZYMz/eQ6V3NfZVsyVnnRdM98=";
  };

  postPatch = ''
      # embed absolute paths
      substituteInPlace cmd/seekwatcher --replace-fail '"blktrace"' '"${blktrace}/bin/blktrace"'
      substituteInPlace cmd/seekwatcher --replace-fail "'blkparse " "'${blktrace}/bin/blkparse "
      # always expose `fable
      substituteInPlace cmd/seekwatcher --replace-fail '"ffmpeg ' '"${lib.getBin ffmpeg}/bin/ffmpeg '
      substituteInPlace cmd/seekwatcher --replace-fail 'check_for_ffmpeg("ffmpeg")' 'True'
  '';

  propagatedBuildInputs = with python3.pkgs; [
    cython numpy matplotlib
  ];

  meta = with lib; {
    description = "Graph the results of a blktrace run";
    homepage = "https://github.com/trofi/seekwatcher";
    license = licenses.gpl2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
