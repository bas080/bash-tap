#!/usr/bin/env bash

source ./bash-tap

plan 1

for file in ./t/*.t; do
  # prevent infinite recursion
  if cmp "$0" "$file" &> /dev/null; then
    continue;
  else
    {
      printf 'source() { return 0; }\n'
      cat ./bash-tap "$file"
    } | sh - | diagnostics
  fi
done

test_success "Can run all tests with sh."
