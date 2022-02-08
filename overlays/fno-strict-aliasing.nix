let
  set_fnsa = attr: attr.overrideAttrs (oa: {
    NIX_CFLAGS_COMPILE = (oa.NIX_COMPILE_CFLAGS or "") + " -fno-strict-aliasing";
  });
  gen_override = prev: pname: {
    name = pname;
    value = set_fnsa prev.${pname};
  };
  gen_overrides = prev: pnames: builtins.listToAttrs (builtins.map (gen_override prev) pnames);
in

# generate overrides in form of:
#  { foo = set_fnsa prev.foo; ... }

final: prev: gen_overrides prev [
  # TODO: fix these upstream
  #"glm"
]
