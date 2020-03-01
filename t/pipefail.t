#!/usr/bin/env bash

source ./bash-tap

plan 1

ls | xargs not-a-command 2>&1 | diagnostics

test_failure "Should fail because wrong is not a valid process"
