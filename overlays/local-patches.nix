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
      ../nix/fix-unexpected-null.patch
      ../nix/swallow-exceptions.patch
    ];
  });
}
