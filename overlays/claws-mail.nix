final: prev: {
  claws-mail = prev.claws-mail.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../claws-mail/show-all-text.patch
    ];
  });
}
