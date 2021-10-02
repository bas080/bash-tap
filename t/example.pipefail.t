#!/usr/bin/env bash

source bash-tap

plan 1

find . -print0 | xargs not-a-command 2>&1 | diagnostics

test_failure "Should fail because not-a-command is not an existant command."
