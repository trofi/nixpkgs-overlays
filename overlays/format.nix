let
  unset_format = attr: attr.overrideAttrs (oa: { hardeningDisable = (oa.hardeningDisable or []) ++ [ "format" ]; });
  gen_override = prev: pname: { name = pname; value = unset_format prev.${pname}; };
  gen_overrides = prev: pnames: builtins.listToAttrs (builtins.map (gen_override prev) pnames);
in

# generate overrides in form of:
#  { foo = unset_format prev.foo; ... }

final: prev: gen_overrides prev [
  # package names go here like "lv"
]
