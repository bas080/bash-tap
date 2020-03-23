# Bash Tap

Minimal tap utilities for (ba)sh scripts.

## Examples

Bash tap is tested with its own testing utilities. These tests also function
as examples on how to use bash tap. The tests are located in the `./t/`
directory.

The following is an example of a test where it isn't clear how many tests will
be run. It possible to have bash tap append the plan at the end of the test
run.

```
$ cat ./t/example.append-plan.t
#!/usr/bin/env bash

source ./bash-tap

ok "One"
(exit 0); test_success "Two"

plan
```

```
$ ./t/example.append-plan.t
ok - One
ok - Two
1..2
```

See the `./t/` directory for more examples.

A test that will output tap based on the exit code.

```
$ ./t/example.process.t
1..1
# hello world
ok - Script ./t/example.process.t ran successfuly.
```

## Documentation

The ./README.md is generated using [barkdown][2]. To regenerate simply run
 `$ ./README.bd > README.md`.

## Tests

Tests are located in prove's default ./t directory. This is how to run them:

```
$ prove # runs all tests
t/example.aliases.t ................ ok
t/example.append-plan.t ............ ok
t/example.dash.t ................... ok
t/example.not_ok_causes_failure.t .. ok
t/example.ok.t ..................... ok
t/example.pipefail.t ............... ok
t/example.process.t ................ ok
t/example.skip-all.t ............... skipped: Because that was the intention.
t/example.skip.t ................... ok
t/example.todo.t ................... ok
All tests successful.
Files=10, Tests=15,  0 wallclock secs ( 0.05 usr  0.01 sys +  0.10 cusr  0.05 csys =  0.21 CPU)
Result: PASS
```

```
$ ./t/example.aliases.t # runs a single test
1..2
ok - The test_success alias success works.
ok - The test_failure alias failure works.
```

## License

GNU General Public License 3.0

[1]:https://github.com/bas080/bash-tap.wiki.git
[2]:https://github.com/bas080/barkdown
