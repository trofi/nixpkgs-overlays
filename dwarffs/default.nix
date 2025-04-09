{ lib
, stdenv
, fetchFromGitHub

, boost
, fuse
, nixVersions
, nlohmann_json

, unstableGitUpdater
}:

let
  nix = nixVersions.latest;
in stdenv.mkDerivation rec {
  pname = "dwarffs";
  version = "3.0.0-unstable-2024-12-02";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "dwarffs";
    rev = "09f5b6d21ce35fc1de2fd338faa89d0618534ef1";
    sha256 = "sha256-Flmc3JZFH6pehFZV3FPmwpQtiByWgbdv6INV0LmSb0M=";
  };

  buildInputs = [
    boost
    fuse
    nix
    nlohmann_json
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I ${nix.dev}/include/nix"
    "-I ${nix.dev}/include/nix/main"
    "-I ${nix.dev}/include/nix/store"
    "-I ${nix.dev}/include/nix/util"
    "-D_FILE_OFFSET_BITS=64"
    "-DVERSION=\"${version}\""
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/systemd/system

    cp dwarffs $out/bin/
    ln -s dwarffs $out/bin/mount.fuse.dwarffs

    cp run-dwarffs.mount run-dwarffs.automount $out/lib/systemd/system/

    runHook postInstall
  '';

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package dwarffs --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    url = "https://github.com/edolstra/dwarffs";
  };

  meta = with lib; {
    description = "A filesystem that fetches DWARF debug info from the Internet on demand.";
    homepage = "https://github.com/edolstra/dwarffs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
