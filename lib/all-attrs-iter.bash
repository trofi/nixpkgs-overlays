#!/usr/bin/env bash

# Usage example:
#   ./all-attrs-iter.bash -I nixpkgs=~/n --arg maxDepth 3 --arg verbose 3 --arg ignoreDrvAttrs false

resume_from=${RESUME_FROM}
result=$(mktemp)

while :; do
    printf "Continuing from '$resume_from'\n" >&2
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

    resume_from=$(jq --raw-output '.stop_at' < "$result")

    [[ $resume_from == "null" ]] && break
done

rm "$result"
