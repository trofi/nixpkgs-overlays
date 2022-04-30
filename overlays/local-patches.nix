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
    patches = (oa.patches or []) ++ [
      ../nix/0001-src-libstore-derivations.cc-avoid-istringstream-on-h.patch
    ];
    dontStrip = true;
    separateDebugInfo = false;
    NIX_CFLAGS_COMPILE = "-ggdb3";
  });
}
