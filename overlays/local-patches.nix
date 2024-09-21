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
    cmakeFlags = (oa.cmakeFlags or []) ++ [
      # https://github.com/NixOS/nixpkgs/pull/343565
      "-DCLANG_FORMAT_PATH=${prev.clang-tools}/bin/clang-format"
    ];
  });

  nixVersions = prev.nixVersions // {
    unstable = (prev.nixVersions.latest or prev.nixVersions.unstable).overrideAttrs(oa: {
      patches = (oa.patches or []) ++ [
        ../nix/editor-no-nl.patch
      ];
    });
  };

  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ prev.lib.optionals (oa.version == "2.0.6")  [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
