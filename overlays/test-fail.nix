let
  set_fcommon = attr: attr.overrideAttrs (oa: {
    NIX_CFLAGS_COMPILE = (oa.NIX_COMPILE_CFLAGS or "") + " -std=c++14";
  });
  gen_override = prev: pname: {
    name = pname;
    value = set_fcommon prev.${pname};
  };
  gen_overrides = prev: pnames: builtins.listToAttrs (builtins.map (gen_override prev) pnames);
in

# generate overrides in form of:
#  { foo = set_fcommon prev.foo; ... }

final: prev: gen_overrides prev [
  # TODO: fix these upstream

  # the whole file does not quite work, all are commented out

  #"gbenchmark" # most tests fail?

  #"tectonic" fails test "redbox_png", rust update?
  #"perl-GD" fails test
  #"volk"
  #"netcdf-4"
  #"patchutils"
  #"perl5.32.1-DBIx-Class"

  # flaky:
  #"python3Packages.pyzmq"
  #"spdlog"
  # "php-intl" tests fail

  #"arc_unpacker" # needs older boost
]
