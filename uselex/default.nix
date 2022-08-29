{ lib
, stdenv
, fetchFromGitHub

, ruby_3_1
, binutils-unwrapped-all-targets

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "uselex";
  version = "unstable-2017-07-28";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "uselex";
    rev = "dfddc3dc839500edceca4665af7ee38f90e92081";
    sha256 = "sha256-4/HK+E1iiwMIvDwo+IheA+tETref9tCAG6WcB34CbKE=";
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
