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
  version = "unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "audio_pump_demo";
    rev = "5b1486d7b3d5d62532e7bb2f54fc6046e04fbed5";
    sha256 = "sha256-uSrGydogYSwxiOVDoz+a82P/VcdItwa8LDlptg6gH8U=";
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
