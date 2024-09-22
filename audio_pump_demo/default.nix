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
  version = "0-unstable-2024-06-18";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "audio_pump_demo";
    rev = "f8cb905c402f599104d736a6c57f98bc2967cded";
    hash = "sha256-LTlBV9FJfLhNghuv7J4O/ro/uAR1b5IAFImKagIuhSQ=";
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
