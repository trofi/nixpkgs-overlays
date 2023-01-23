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
  version = "unstable-2023-01-19";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "audio_pump_demo";
    rev = "48eb3ebf031973cd2b70dffc0b056a1b67100958";
    sha256 = "sha256-5sV5PjiuVT7anv5mJpsnwZ6cKSvZzQe2asvZyb+XZvk=";
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
