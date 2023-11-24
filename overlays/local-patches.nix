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

  duperemove = prev.duperemove.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      # One of the pending fixes for:
      #   https://github.com/markfasheh/duperemove/issues/329
      (prev.fetchpatch {
        name = "skip-inline.patch";
        url = "https://github.com/markfasheh/duperemove/commit/eeeddca9f8820594d872366f74a4c01fc9377d9c.patch";
        hash = "sha256-Q6kwNJEJIXSAI+Ec968KH0uloohAwq1Tu72pzyrQJVU=";
      })
    ];
  });

  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
