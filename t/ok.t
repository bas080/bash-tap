#!/usr/bin/env bash

source ./bash-tap

plan 2

ok "Just pass the thing"

(exit 0)
test_success "Exit code is a success"
