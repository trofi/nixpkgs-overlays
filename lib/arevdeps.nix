# Get packages which derivation mentions passed in dependency explicitly
#
# 1. instantiate a `.drv` file of seached attribute output to get it's store path
# 2. instantiate `.drv` files of each derivation found in packages attribute set
# 3. if [1.] string is found in [2.] string then [2.] is a direct reverse dependency
#
# use as:
#    $ nix-instantiate --impure --read-write-mode --eval --strict arevdeps.nix --argstr attrName <attr-to-find>
# example
#    $ nix-instantiate --impure --read-write-mode --eval --strict ~/.config/nixpkgs/lib/arevdeps.nix --argstr attrName re2c -I nixpkgs=$PWD
#
# TODO: still quite hacky:
# - it skips many attributes in an ad-hoc manner
# - .drv file reading is a bit messy: amount of evals should be decreased
{ nixpkgs ? import <nixpkgs> {
    config = {
      # alias evaluation always fails
      allowAliases = false;
      # broken and unfree normally evaluate, just don't build
      #TODO: a few coq packages are using invalid attributes
      #allowBroken = true;
      #allowUnfree = true;
    };
  }
, attrName
, rootAttr ? "pkgs"
, verbose ? 1
, depth ? 10
}:

let
  # simple variables:
  lib = nixpkgs.lib;

  # logging:
  err  = s: e: lib.trace "ERROR: ${s}" e;
  warn = s: e: if verbose >= 1 then lib.trace "WARNING: ${s}" e else e;
  info = s: e: if verbose >= 2 then lib.trace "INFO: ${s}" e else e;

  root = lib.attrByPath (lib.splitString "." rootAttr)
                        (warn "did not find ${rootAttr}" {})
                        nixpkgs;
  attr = lib.attrByPath (lib.splitString "." attrName)
                        (err "did not find ${attrName}" {})
                        nixpkgs;


  # constants, taken from pkgs/top-level/release-attrpaths-superset.nix
  ignoreTopLevel = [
    # just to remove a warning
    "AAAAAASomeThingsFailToEvaluate"

    # spliced packagesets
    "__splicedPackages"
    "pkgsBuildBuild"
    "pkgsBuildHost"
    "pkgsBuildTarget"
    "pkgsHostHost"
    "pkgsHostTarget"
    "pkgsTargetTarget"
    "buildPackages"
    "targetPackages"

    # cross packagesets
    "pkgsLLVM"
    "pkgsMusl"
    "pkgsStatic"
    "pkgsCross"
    "pkgsi686Linux"

    # workarounds: fecth files from internet
    "vmTools"
    # workaround: infinite recursion:
    #   tests.cross.gcc.pkg-config.aarch64-android:
    "tests"

    # workaround: eats too much RAM
    #   https://github.com/NixOS/nix/issues/9671
    "nixosTests"
    # workaround: eats a lot of RAM
    "haskell"

    # workaround: odd names: with "@"
    "nodePackages"
    "nodePackages_latest"
  ];
  ignoreAnyLevel = [
    "lib"
    "override"
    "__functor"
    "__functionArgs"
    "newScope"
    "scope"
    "pkgs"

    "buildHaskellPackages"
    "buildPackages"
    "generateOptparseApplicativeCompletions"

    "callPackage"
    "mkDerivation"
    "overrideDerivation"
    "overrideScope"
    "overrideScope'"

    # Special case: lib/types.nix leaks into a lot of nixos-related
    # derivations, and does not eval deeply.
    "type"

    # workarounds: fail evaluation
    "__attrsFailEvaluation"
    #   example: swiftPackages.darwin.adv_cmds
    "darwin"
    # example: haskell.packages.ghc810.stack
    "stack"
    "ghc810"
    "ghc8107"
    "ghc865Binary"
    "ghcjs"
    "ghcjs810"
    "ocaml-ng"

    # has errors:
    "janeStreet_0_15"
    "ocamlPackages_4_14_janeStreet_0_15"
  ];

  # helpers
  safeNameEval = ap: expr: let c = builtins.tryEval expr; in if c.success then c.value else warn "bad expression in one of the names in a=${lib.concatStringsSep "." ap}" "BAD-NAME-EXPR";
  safeReadFile = ap: df: let safe_df = safeNameEval ap df; c = builtins.tryEval (builtins.readFile safe_df); in if safe_df != "BAD-NAME-EXPR" && c.success then c.value else "";
  fastHasEntry = i: s: s != builtins.replaceStrings [i] ["<FOUND-HERE>"] s;
  sInDrv = ap: s: d: fastHasEntry s (safeReadFile ap d.drvPath);
  rdepInDrv = ap: rdep: d: builtins.any (s: sInDrv ap s d)
                                        (builtins.map (o: rdep.${o}.outPath) rdep.outputs);

  # functions:
  go = ap: v: acc:
    info "Inspecting attribute path ${lib.concatStringsSep "." ap}" (
    let
      ap_last2rev = lib.take 2 (lib.reverseList ap);
      e = builtins.tryEval v; in
    if !e.success then warn "a=${lib.concatStringsSep "." ap} fails to evaluate" acc else
    # TODO: insert cutoffs in infinitely recursive attributes
    if lib.length ap > depth
    then warn "too deep (depth=${toString depth}) nesting of a=${lib.concatStringsSep "." ap}. Bailing out" acc
    # skip infinite self-referring attrsets. Typical examples are:
    #   pythonPackages = self;
    #   coqPackages = self;
    else if ap_last2rev == ["beamPackages" "beamPackages"]
         || ap_last2rev == ["buildRustPackages" "buildRustPackages"]
         || ap_last2rev == ["coqPackages" "coqPackages"]
         || ap_last2rev == ["cudaPackages" "cudaPackages"]
         || ap_last2rev == ["luaPackages" "luaPackages"]
         || ap_last2rev == ["perlPackages" "perlPackages"]
         || ap_last2rev == ["pidginPackages" "pidginPackages"]
         || ap_last2rev == ["pythonPackages" "pythonPackages"]
         || ap_last2rev == ["quicklisp-to-nix-packages" "quicklisp-to-nix-packages"]
    then acc
    else if lib.isDerivation v && !lib.hasAttr "drvPath" v
    then warn "a=${lib.concatStringsSep "." ap} derivation without a .drvPath" acc
    # packages marked broken and having other eval problems
    # TODO: ad more fine-grained scanning for failures
    else if lib.isDerivation v && !(builtins.tryEval v.drvPath).success
    then acc
    else if lib.isDerivation v
    then (if rdepInDrv ap attr v then acc ++ [(lib.concatStringsSep "." ap)] else acc)
    else if lib.isAttrs v
    then lib.foldl' (r: nv: go (ap ++ [(safeNameEval ap nv.name)]) nv.value r) acc (lib.attrsToList (removeAttrs v ignoreAnyLevel))
    # completely skip non-data:
    else if lib.isFunction v || lib.isString v || lib.isBool v || lib.isList v || lib.isInt v || lib.isPath v || v == null
    then acc
    # ideally should not get here
    else warn "unhandled a=${lib.concatStringsSep "." ap} type" acc);

  # actual computation
  # Final result. List of attribute components, like:
  #     ["nixVersions.nix_2_3" "re2c" ...]
  result = go [] (removeAttrs root ignoreTopLevel) [];
in result
