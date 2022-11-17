final: prev: {
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

  nixUnstable = prev.nixUnstable.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      # https://github.com/NixOS/nix/pull/7283
      (prev.fetchpatch {
        name = "dupes.patch";
        url = "https://github.com/NixOS/nix/commit/7e162c69fe6cbfb929b5356a7df9de5c25c22565.patch";
        hash = "sha256-8DX4spZOvgg5214HZdaUrFv4jkYEQhjckxOSiAkC0Cg=";
      })
    ];
    #dontStrip = true;
    #separateDebugInfo = false;
    #NIX_CFLAGS_COMPILE = "-ggdb3";
  });

  /*
  xorg = prev.xorg.overrideScope' (f: p: {
    libXfont2 = p.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  }) // { inherit (prev) xlibsWrapper; };
  */
  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
