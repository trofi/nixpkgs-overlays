# Print "all" attribute names present in `nixpkgs` that point to
# derivations.

# Usage example:
# $ nix-instantiate --eval --strict ~/.config/nixpkgs/lib/all-attrs.nix -I nixpkgs=$PWD --arg maxDepth 2 --arg verbose 3

# TODOs:
# - remove clearly redundant attributes (similar to hydra, but leave
#   user-facing `pkgs*` to validate those.
# - add an option to recurse into derivations themselves to test
#   `passthru.*` and `metadata.*` attributes syntax correctness.
{ nixpkgs ? import <nixpkgs> {
    config = {
      # TODO:
      #allowAliases = false;
      #allowBroken = true;
      #allowUnfree = true;
    };
  }
, rootAttr ? "pkgs"
, verbose ? 1 # warn

# How to pick, resource usage for me as of 2023-12-28:
# 1 - 10 seconds, ~2GB of RAM
# 2 - 2 minutes, ~25GB of RAM (unfiltered attrs)
# 3 - 5+ minutes, ~70GB+ or RAM Fails on attributes like `pkgsCross.iphone32.ammonite`
# anything else: at your risk
, maxDepth
}:

let
  # simple variables:
  lib = nixpkgs.lib;

  # logging:
  err   = s: e: lib.trace "ERROR: ${s}" e;
  warn  = s: e: if verbose >= 1 then lib.trace "WARN: ${s}" e else e;
  info  = s: e: if verbose >= 2 then lib.trace "INFO: ${s}" e else e;
  debug = s: e: if verbose >= 3 then lib.trace "DEBUG: ${s}" e else e;

  # root to start at
  root = lib.attrByPath (lib.splitString "." rootAttr)
                        (warn "did not find ${rootAttr}" {})
                        nixpkgs;
  # other helpers:
  isPrimitive = v: lib.isFunction v
                || lib.isString v
                || lib.isBool v
                || lib.isList v
                || lib.isInt v
                || lib.isPath v
                || v == null;

  go = depth: ap: v:
    let
      a = lib.showAttrPath ap;
      e = builtins.tryEval v;
      maybe_go_deeper =
        if depth >= maxDepth
        then info "too deep (depth=${toString depth}) nesting of a=${a}, stop" []
        else map (nv: go (depth + 1) (ap ++ [nv.name]) nv.value)
                 (lib.attrsToList v);
    in debug "inspecting ${a}" (
    if !e.success then info "${a} fails to evaluate" []
    else if lib.isDerivation v
    # TODO: add an option to traverse into derivations as well.
    # Mainly to test validity of `passthru.tests`, `metadata` and
    # similar.
    then [a] # TODO: "++ maybe_go_deeper"
    else if lib.isAttrs v then maybe_go_deeper
    else if isPrimitive v then []
    # should not get here
    else warn "unhandled type of ${a}" []);
in lib.flatten (go 0 [] root)
