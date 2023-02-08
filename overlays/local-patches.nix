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

  # a milder form of https://github.com/NixOS/nixpkgs/pull/215272
  vifm = prev.vifm.overrideAttrs (oa: {
    nativeBuildInputs = [ prev.perl ] ++ oa.nativeBuildInputs;
    postPatch = ''
      # Avoid '#!/usr/bin/env perl' reverences to build help.
      patchShebangs --build src/helpztags
    '' + (oa.postPatch or "");
  });

  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
