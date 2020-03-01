#!/usr/bin/env bash

source ./bash-tap

plan 1

for file in ./t/*.t; do
  # prevent infinite recursion
  cmp "$0" $file &> /dev/null && continue || true

  {
    printf 'source() { return 0; }\n'
    cat ./bash-tap "$file"
  } | sh - | diagnostics
done

test_success "Can run all tests with sh."
