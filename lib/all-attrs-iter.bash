#!/usr/bin/env bash

# Usage example:
#   ./all-attrs-iter.bash -I nixpkgs=~/n --arg maxDepth 3 --arg verbose 2 --arg ignoreDrvAttrs false --arg stepLimit 10000

resume_from=${RESUME_FROM}
if [[ -z ${resume_from} ]]; then
    resume_from="[]"
fi
result=$(mktemp)

while :; do
    printf "Continuing from '%s'\n" "${resume_from}" >&2
    nix-instantiate --strict --eval --read-write-mode \
        all-attrs-iter.nix \
        --arg resumeFrom "$resume_from" \
        \
        "$@" >"$result"
    status=$?

    [[ $status -ne 0 ]] && break

    #echo raw result:
    #cat "$result"
    #echo "status: $status"

    next_attr=$(nix-instantiate --strict --eval --expr "{result}: result.stop_at" --arg result "$(< "$result")")
    if [[ "${next_attr}" == "${resume_from}" ]]; then
        printf "ERROR: stuck on '%s' attribute\n" "${next_attr}" >&2
        break
    fi
    resume_from=${next_attr}

    # TODO: how to express success? add a bool attribute
    [[ $resume_from == "[ ]" ]] && break
done

rm "$result"
