#!/usr/bin/env bash

source ./bash-tap

plan 2

test "$(test_success)" = "$(success)"
success "The test_success alias success works."

# shellcheck disable=SC2119
test "$(test_failure)" = "$(failure)"
success "The test_failure alias failure works."
