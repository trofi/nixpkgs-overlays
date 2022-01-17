# use as:
#    import ~/.config/nixpkgs/lib/arevdeps.nix linuxHeaders pkgs lib
revdepAttr: pkgs: lib:
let isDrv = v: (builtins.tryEval v).success && lib.isDerivation v;
    # skip broken and unsupported packages on this system in a very crude way:
    safeReadFile = df: let c = builtins.tryEval (builtins.readFile df); in if c.success then c.value else "";
    fastHasEntry = i: s: s != builtins.replaceStrings [i] ["<FOUND-HERE>"] s;
    sInDrv = s: d: fastHasEntry s (safeReadFile d.drvPath);
    rdepInDrv = rdep: d: builtins.any (s: sInDrv s d)
                                      (builtins.map (o: rdep.${o}.outPath) rdep.outputs);
    matchedPackages = lib.filterAttrs (n: d: isDrv d && rdepInDrv revdepAttr d)
                                      pkgs;
in builtins.attrNames matchedPackages
