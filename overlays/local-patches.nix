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

  xorg = prev.xorg.overrideScope' (f: p: {
    libXfont2 = p.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  });
}
