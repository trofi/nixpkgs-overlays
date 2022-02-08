# Get packages which build input names patch passed package
#
# use as:
#    import ./revdeps.nix "texinfo" pkgs lib
revdep: pkgs: lib:
let isDrv = v: (builtins.tryEval v).success && lib.isDerivation v;
    isDrvName = name: d: isDrv d && lib.strings.hasPrefix name d.name;
    getList = a: s: if builtins.hasAttr a s then builtins.getAttr a s else [];
    matchedPackages = lib.filterAttrs (n: v: isDrv v
                                             && builtins.any (isDrvName revdep)
                                                             (getList "buildInputs" v
                                                              ++ getList "nativeBuildInputs" v))
                                      pkgs;
in
  builtins.attrNames matchedPackages
