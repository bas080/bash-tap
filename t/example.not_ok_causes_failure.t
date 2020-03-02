#!/usr/bin/env bash

source ./bash-tap

plan 2

(
  source ./bash-tap
  plan 1
  not_ok "This not ok will cause the process to fail."
) | diagnostics
test_failure "The process failed because of a not ok. (not_ok)"

(
  source ./bash-tap
  plan 1
  test_failure "This not ok will cause the process to fail."
) | diagnostics
test_failure "The process failed because of a not ok. (test_failure)"
