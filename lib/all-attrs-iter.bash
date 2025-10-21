#!/usr/bin/env bash

# Usage example:
#   ./all-attrs-iter.bash -I nixpkgs=~/n --arg maxDepth 3 --arg verbose 3 --arg ignoreDrvAttrs false

resume_from=${RESUME_FROM}
result=$(mktemp)

while :; do
    printf "Continuing from '%s'\n" "${resume_from}" >&2
    nix-instantiate --json --strict --eval --read-write-mode \
        all-attrs-iter.nix \
        --arg maxDepth 1 \
        --argstr resumeFrom "$resume_from" \
        \
        "$@" >"$result"
    status=$?

    [[ $status -ne 0 ]] && break

    #echo raw result:
    #cat "$result"
    #echo result:
    #jq <"$result"
    #echo "status: $status"

    next_attr=$(jq --raw-output '.stop_at' < "$result")
    if [[ "${next_attr}" == "${resume_from}" ]]; then
        printf "ERROR: stuck on '%s' attribute\n" "${next_attr}" >&2
        break
    fi
    resume_from=${next_attr}

    [[ $resume_from == "null" ]] && break
done

rm "$result"
