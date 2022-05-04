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

  nix = prev.nix.overrideAttrs(oa: {
    src = prev.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "470e27ce8008ba952225b9f9f7f61a9627376f33";
      hash = "sha256-BpEL913l/DfDsXzlAcQbmUrKFT5QIxl2YzhOK/fSdH0=";
    };
    patches = (oa.patches or []) ++ [
      ../nix/0001-src-libstore-derivations.cc-avoid-istringstream-on-h.patch
    ];
    dontStrip = true;
    separateDebugInfo = false;
    NIX_CFLAGS_COMPILE = "-ggdb3";
  });
}
