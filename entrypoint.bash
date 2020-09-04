#!/usr/bin/env bash

set -o errexit
set -o pipefail

mapfile -t jsonnetFiles < <(
    find "$GITHUB_WORKSPACE" \
        -name 'vendor' -prune \
        -o -name '*.libsonnet' -print \
        -o -name '*.jsonnet' -print
)

cd "$GITHUB_WORKSPACE"
fail=0
for i in "${jsonnetFiles[@]}"; do
    set +o errexit
    jsonnet-lint --jpath "$GITHUB_WORKSPACE" --jpath "$GITHUB_WORKSPACE"/vendor/ "$i"
    # shellcheck disable=SC2181
    if [ $? -gt 0 ]; then
        fail=1
    fi
    set -o errexit
done

if [ $fail -eq 1 ]; then
    return 1
fi
