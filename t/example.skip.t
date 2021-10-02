#!/usr/bin/env bash

source bash-tap

plan 2

skip "Testing that the first test is skipped."

ok "The second test is not skipped."
