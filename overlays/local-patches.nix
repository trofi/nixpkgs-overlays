final: prev: {
  claws-mail = prev.claws-mail.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../claws-mail/show-all-text.patch
    ];
  });

  xwayland = prev.xwayland.override {
    libxfont_2 = prev.libxfont_2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ prev.lib.optionals (oa.version == "2.0.6")  [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
