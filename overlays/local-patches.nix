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
      # Fix for SIGSEGV:
      #   https://github.com/markfasheh/duperemove/issues/332
      (prev.fetchpatch {
        name = "SEGV-on-extents.patch";
        url  = "https://github.com/markfasheh/duperemove/commit/9912c03c16af67e33b5dc36052e8faed9a17749d.patch";
        hash = "sha256-+YGAtfILWpcmYtt5hmKut8ND3+yJLZ76iInIYqyESOQ=";
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
