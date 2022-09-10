{ lib
, stdenv
, fetchFromGitHub

, ruby_3_1
, binutils-unwrapped-all-targets

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "uselex";
  version = "unstable-2022-08-29";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "uselex";
    rev = "5cf79a872f3331ce87171e66cf27c430585f65af";
    sha256 = "sha256-0aFJaGLcrrEkOH3cFs2uHjkCUw9ndckngfnb0J1FK7c=";
  };

  buildInputs = [ ruby_3_1 ];

  postPatch = ''
    patchShebangs

    substituteInPlace uselex.rb --replace "'nm'" "'${binutils-unwrapped-all-targets}/bin/nm'"
  '';

  installPhase = ''
    install -d $out/bin
    install -m 0755 uselex.rb $out/bin
  '';

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package uselex --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/trofi/uselex";
  };

  meta = with lib; {
    description = "Look for USEless EXports in object files.";
    homepage = "https://github.com/trofi/uselex";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.all;
  };
}
