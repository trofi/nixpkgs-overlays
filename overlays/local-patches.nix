final: prev: {
  # https://github.com/NixOS/nixpkgs/pull/169907
  binutils-unwrapped-all-targets = prev.binutils-unwrapped-all-targets.overrideAttrs(oa: {
    postFixup = "";
  });

  claws-mail = prev.claws-mail.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../claws-mail/show-all-text.patch
    ];
  });

  cvise = prev.cvise.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../cvise/reverse-lines.patch
    ];
  });

  liferea = prev.liferea.overrideAttrs(oa: {
    src = let ver = "1.13.8"; in prev.fetchurl {
      url = "https://github.com/lwindolf/liferea/releases/download/v${ver}/liferea-${ver}.tar.bz2";
      sha256 = "sha256-EAiugFGSgWsZDwfGyOCUJWvFuIBi9drxpxAlC+0pSHQ=";
    };
  });

  nixUnstable = prev.nixUnstable.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../nix/0001-src-libstore-derivations.cc-avoid-istringstream-on-h.patch
      ../nix/0001-src-libutil-json.cc-add-missing-cstdint-include-for-.patch
    ];
    dontStrip = true;
    separateDebugInfo = false;
    NIX_CFLAGS_COMPILE = "-ggdb3";
  });
}
