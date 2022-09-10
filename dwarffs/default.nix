{ lib
, stdenv
, fetchFromGitHub

, boost
, fuse
, nix
, nlohmann_json

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "dwarffs";
  version = "unstable-2022-09-06";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "dwarffs";
    rev = "1f850df9c932acb95da2f31b576a8f6c7c188376";
    sha256 = "sha256-HBgQB8jzmpBTHAdPfCtLnxVhHSzI3XtSfcMW2TZ0KN8=";
  };

  buildInputs = [ fuse nix nlohmann_json boost ];
  NIX_CFLAGS_COMPILE = "-I ${nix.dev}/include/nix -include ${nix.dev}/include/nix/config.h -D_FILE_OFFSET_BITS=64 -DVERSION=\"${version}\"";

  installPhase = ''
    mkdir -p $out/bin $out/lib/systemd/system

    cp dwarffs $out/bin/
    ln -s dwarffs $out/bin/mount.fuse.dwarffs

    cp run-dwarffs.mount run-dwarffs.automount $out/lib/systemd/system/
  '';

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package dwarffs --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
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
