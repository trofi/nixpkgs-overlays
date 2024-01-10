# Print "all" attribute names present in `nixpkgs` that point to
# derivations iteratively. One has to call this script externally
# to get the full list. The external driver needs to workaround ever
# growing RAM usage by `nix` when it comes to parge trees traversal:
#   https://github.com/NixOS/nix/issues/9671

# TODO: an external script to drive it.

# Implementation:
# - We track the depth and progress of a tree traversal and bail out from
#   the traversal when we reach allowed limit (say, 1000 steps).
# - We return the progress so far to continue from there.

# Usage example:
# TODO

{ nixpkgs ? import <nixpkgs> {
    config = {
      # TODO:
      #allowAliases = false;
      #allowBroken = true;
      #allowUnfree = true;
    };
  }
, rootAttr ? null
, verbose ? 1 # warn

, maxDepth
# last item processed successfully
, resumeFrom ? null
, stepLimit ? 1000

, ignoreCross ? true

# Whether to validate every attribute within derivations themselves.
# Most intereting fields are `passthru.tests`, but sometimes there are
# very unusual bugs lurking. Risky but very fun!
, ignoreDrvAttrs ? true
}:

let
  # simple variables:
  lib = nixpkgs.lib;
  ignorable = import ./ignorable-attrs.nix {
    inherit lib;
    inherit ignoreCross;
    inherit ignoreDrvAttrs;
  };

  # logging:
  err   = s: e: lib.trace "ERROR: ${s}" e;
  warn  = s: e: if verbose >= 1 then lib.trace "WARN: ${s}" e else e;
  info  = s: e: if verbose >= 2 then lib.trace "INFO: ${s}" e else e;
  debug = s: e: if verbose >= 3 then lib.trace "DEBUG: ${s}" e else e;

  # root to start at
  rap = if rootAttr != null
        then lib.splitString "." rootAttr
        else [];
  root = lib.attrByPath rap
                        (warn "did not find ${rootAttr}" {})
                        nixpkgs;

  start_depth = lib.length rap;
  # attribute path relative to the specified root
  resumeap = if resumeFrom != null
             then lib.drop start_depth (lib.splitString "." resumeFrom)
             else [];

  # other helpers:
  isPrimitive = v: lib.isFunction v
                || lib.isString v
                || lib.isBool v
                || lib.isList v
                || lib.isInt v
                || lib.isPath v
                || v == null;


  go = depth: ap: tree: pos: {result, left, stop_at}@args:
    let
      a = lib.showAttrPath ap;
      e = builtins.tryEval tree;
      ignoreList = if depth == 0 || depth == start_depth
                   then ignorable.topLevel
                   else ignorable.anyLevel;
      skip = args // { left = left - 1; }
                  // (if left == 0 then { stop_at = a; } else {});

      # Val: { name, value }
      # :: Ctx -> Val -> Ctx
      # :: Ctx -> [Val] -> Ctx
      add_val = ctx: v: ctx // { left = left - 1; }
                            // (
        if left < 0 then {}
        else if left == 0 then { stop_at = a; }
        else { result = result ++ [v.name]; });
      # TODO: ignore list / skip list
      # TODO: short-circuit fold when the limit is hit
      add_vals = ctx: vs:
        if lib.length pos > 0
        then let
          ph = lib.head pos;
          pt = lib.tail pos;
          # TODO: could implement a dropWhile as an optimization
          # TODO: unify with a default case
          # TODO: carefully examine if we skip subtrees, rescan them or all is fine
          fvs = lib.filter (v: !(v.name < ph)) vs;
        in lib.foldl' (c: v: go (depth + 1) (ap ++ [v.name]) v.value (if v.name == ph then pt else []) c) ctx fvs
        else lib.foldl' (c: v: go (depth + 1) (ap ++ [v.name]) v.value [] c) ctx vs;

      maybe_go_deeper =
        if depth >= maxDepth
        then info "too deep (depth=${toString depth}) nesting of a=${a}, stop" skip
        else add_vals args (lib.attrsToList tree);
    in debug "inspecting ${a} (depth=${toString depth}, left=${toString left})" (
    if      left == 0 then info "${a}: hit step limit" skip
    else if left < 0 then info "${a}: previous leaf hit step limit, just skip" skip
    else if !e.success then info "${a} fails to evaluate" skip
    else if isPrimitive tree then skip
    else if lib.isDerivation tree then add_val (if ignoreDrvAttrs then skip else maybe_go_deeper) {name=a; value=tree;}
    # Skip "foo = self;" attributes like `pythonPackages.pythonPackages`
    # TODO: might skip too much.
    else if lib.isAttrs tree && depth > 0 && lib.hasAttr (lib.last ap) tree && rootAttr != a then info "${a} is a repeated attribute, skipping" skip
    else if lib.isAttrs tree then maybe_go_deeper
    # should not get here
    else warn "unhandled type of ${a}" skip);
in removeAttrs (go start_depth rap root resumeap {
  result = [];
  stop_at = null;
  left = stepLimit;
}) ["tree"]
