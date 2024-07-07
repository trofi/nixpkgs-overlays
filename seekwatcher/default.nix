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
      substituteInPlace --replace-fail cmd/seekwatcher --replace '"blktrace"' '"${blktrace}/bin/blktrace"'
      substituteInPlace --replace-fail cmd/seekwatcher --replace "'blkparse " "'${blktrace}/bin/blkparse "
      # always expose `ffmpeg` as available
      substituteInPlace --replace-fail cmd/seekwatcher --replace '"ffmpeg ' '"${lib.getBin ffmpeg}/bin/ffmpeg '
      substituteInPlace --replace-fail cmd/seekwatcher --replace 'check_for_ffmpeg("ffmpeg")' 'True'
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
