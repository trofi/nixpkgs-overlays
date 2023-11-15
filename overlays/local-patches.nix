final: prev: {
  claws-mail = prev.claws-mail.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../claws-mail/show-all-text.patch
    ];
  });

  cvise = prev.cvise.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../cvise/reverse-lines.patch

      # Keep locally until it's upstream:
      #   https://github.com/NixOS/nixpkgs/pull/267736
      #
      # Refer to shell via /usr/bin/env:
      #   https://github.com/marxin/cvise/pull/121
      (prev.fetchpatch {
        name = "env-shell.patch";
        url = "https://github.com/marxin/cvise/commit/6a416eb590be978a2ad25c610974fdde84e88651.patch";
        hash = "sha256-Kn6+TXP+wJpMs6jrgsa9OwjXf6vmIgGzny8jg3dfKWA=";
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
