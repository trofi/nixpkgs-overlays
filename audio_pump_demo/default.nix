{ lib
, stdenv
, fetchFromGitHub

, SDL2
, pkg-config
, portaudio
, pulseaudio

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "audio_pump_demo";
  version = "0-unstable-2024-10-28";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "audio_pump_demo";
    rev = "fd8bb58eea6c4047d9653337fe97413569bf799a";
    hash = "sha256-Hpyf48ADhowR2ipXB6f5pQiAVv5N6HXY7V5LQeub91U=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 portaudio pulseaudio ];

  makeFlagsArray = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package audio_pump_demo --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/hartwork/audio_pump_demo.git";
  };

  meta = with lib; {
    description = "Audio pump demo";
    homepage = "https://github.com/hartwork/audio_pump_demo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
