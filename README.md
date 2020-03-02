# Bash Tap

Minimal tap utilities for (ba)sh scripts.

## Examples

### ./t/example.aliases.t

```bash
#!/usr/bin/env bash

source ./bash-tap

plan 2

test "$(test_success)" = "$(success)"
success "The test_success alias success works."

test "$(test_failure)" = "$(failure)"
success "The test_failure alias failure works."
```

```tap
1..2
ok - The test_success alias success works.
ok - The test_failure alias failure works.
```

### ./t/example.dash.t

```bash
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
```

```tap
1..1
# 1..2
# ok - The test_success alias success works.
# ok - The test_failure alias failure works.
# 1..2
# ok - Just pass the thing
# ok - Exit code is a success
# 1..1
# # xargs: not-a-command: No such file or directory
# not ok - Should fail because not-a-command is not an existant command.
# 1..0 # skip Because that was the intention.
# 1..2
# ok - # skip Testing that the first test is skipped.
# ok - The second test is not skipped.
# 1..2
# not ok - # TODO This
# not ok - # TODO That
ok - Can run all tests with sh.
```

### ./t/example.ok.t

```bash
#!/usr/bin/env bash

source ./bash-tap

plan 2

ok "Just pass the thing"

(exit 0)
test_success "Exit code is a success"
```

```tap
1..2
ok - Just pass the thing
ok - Exit code is a success
```

### ./t/example.pipefail.t

```bash
#!/usr/bin/env bash

source ./bash-tap

plan 1

ls | xargs not-a-command 2>&1 | diagnostics

test_failure "Should fail because not-a-command is not an existant command."
```

```tap
1..1
# xargs: not-a-command: No such file or directory
ok - Should fail because not-a-command is not an existant command.
```

### ./t/example.skip-all.t

```bash
#!/usr/bin/env bash

source ./bash-tap

skip_all "Because that was the intention."
```

```tap
1..0 # skip Because that was the intention.
```

### ./t/example.skip.t

```bash
#!/usr/bin/env bash

source ./bash-tap

plan 2

skip "Testing that the first test is skipped."

ok "The second test is not skipped."
```

```tap
1..2
ok - # skip Testing that the first test is skipped.
ok - The second test is not skipped.
```

### ./t/example.todo.t

```bash
#!/usr/bin/env bash

source ./bash-tap

plan 2

todo "This"
todo "That"
```

```tap
1..2
not ok - # TODO This
not ok - # TODO That
```

## Documentation

This README.md is generated using the [./README](./README) script.

## Tests

Tests are located in prove's default ./t directory. You can run the tests
indivudually by simply executing them; or by using the prove command.

## License

GNU General Public License 3.0
