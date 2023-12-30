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
, rootAttr ? null
, verbose ? 1 # warn

# How to pick, resource usage for me as of 2023-12-28:
# Without ignoreCross:
# - 1 - 10 seconds, ~2GB of RAM
# - 2 - 30 seconds, ~6GB or RAM
# - 3 - 1 minute, ~10GB of RAM
# - 4 - 2 minutes, ~25GB of RAM
# - 5 - 3 minutes, ~50GB of RAM
# With ignoreCross:
# - 1 - 10 seconds, ~2GB of RAM
# - 2 - 2 minutes, ~25GB of RAM (unfiltered attrs)
# - 3 - 5+ minutes, ~70GB+ or RAM Fails on attributes like `pkgsCross.iphone32.ammonite`
# anything else: at your risk
, maxDepth

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
      ignoreList = if depth == 0
                   then ignorable.topLevel
                   else ignorable.anyLevel;
      maybe_go_deeper =
        if depth >= maxDepth
        then info "too deep (depth=${toString depth}) nesting of a=${a}, stop" []
        else map (nv: go (depth + 1) (ap ++ [nv.name]) nv.value)
                 (lib.attrsToList (removeAttrs v ignoreList));
    in debug "inspecting ${a}" (
    if !e.success then info "${a} fails to evaluate" []
    else if isPrimitive v then []
    else if lib.isDerivation v
    then [a] ++ lib.optionals (!ignoreDrvAttrs) maybe_go_deeper
    # Skip "foo = self;" attributes like `pythonPackages.pythonPackages`
    # TODO: might skip too much.
    else if lib.isAttrs v && depth > 0 && lib.hasAttr (lib.last ap) v then info "${a} is a repeated attribute, skipping" []
    else if lib.isAttrs v then maybe_go_deeper
    # should not get here
    else warn "unhandled type of ${a}" []);
in lib.flatten (go (lib.length rap) rap root)
