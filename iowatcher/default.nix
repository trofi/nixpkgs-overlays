{ lib
, stdenv
, fetchgit
, blktrace
, librsvg
, ffmpeg
}:

stdenv.mkDerivation rec {
  pname = "iowatcher";
  version = "1.0+unstable=2014-09-24";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/mason/iowatcher.git";
    rev = "13adc03f658ac7ae0986a0d5b9a20c4ac097209b";
    hash = "sha256-Am0fY0trDLaszKxtuuWUl4uFXiMM7ir67vH8rF7Pr2M=";
  };

  postPatch = ''
      # embed absolute paths
      substituteInPlace tracers.c --replace '"blktrace"' '"${blktrace}/bin/blktrace"'
      substituteInPlace main.c    --replace ' rsvg-convert ' ' ${librsvg}/bin/rsvg-convert '
      substituteInPlace main.c    --replace '"ffmpeg ' '"${ffmpeg.bin}/bin/ffmpeg '
  '';

  makeFlags = ["prefix=${placeholder "out"}"];

  meta = with lib; {
    description = "Graph the results of a blktrace run";
    homepage = "http://masoncoding.com/iowatcher/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
