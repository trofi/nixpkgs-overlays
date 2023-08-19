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

  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  };

  duperemove = prev.duperemove.overrideAttrs (oa: {
    patches = (oa.patches or []) ++ [
      # Fix infinite loops on empty files.
      (prev.fetchpatch {
        name = "no-infinite.patch";
        url = "https://github.com/markfasheh/duperemove/commit/0a48cecfb19fe8d5f8b6b96b86fac59b218aab6d.patch";
        hash = "sha256-lctmJOZwK/M7q4Rov7xPsSg3SR4f+dwN6U9hB32jxyM=";
      })
    ];
  });
}
