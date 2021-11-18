# Bash Tap

Minimal tap utilities for (ba)sh scripts.

## Usage

source bash-tap into your `bash` or `sh` script and use one or more of the
functions provided.

Here is an example of sourcing bash-tap. This approach will require you to have
the bash-tap file placed in one of the `$PATH` directories.

```bash ./test source-using-path-variable.t
source bash-tap

plan 1
ok "Sourced using PATH variable."
```
```
1..1
ok - Sourced using PATH variable.
```

You can also define the absolute or relative path to the bash-tap file.

```bash ./test source-using-relative-path.t
source ./bash-tap

plan 1
ok "Sourced using relative path."
```
```
1..1
ok - Sourced using relative path.
```

## Examples

Bash tap is tested with its own testing utilities. These tests also function
as examples on how to use bash tap.

TAP tests are required to have a plan defined. Otherwise it is not considered
a valid test run. Here is an example of a test run with 0 assertions.

```bash ./test plan.t
plan 0
```
```
1..0
```

The ok function simply prints out an TAP ok line.

```bash ./test ok.t
plan 1
ok "Is ok."
```
```
1..1
ok - Is ok.
```

Sometimes you don't know how many tests will be run. For those cases it is
possible to have bash-tap append the plan to the TAP output after all
assertions have been run.

```bash ./test append-plan.t
ok "First ok."
ok "Second ok."
ok "Third ok."
plan
```
```
ok - First ok.
ok - Second ok.
ok - Third ok.
1..3
```

While maintaining the test suite it might be nice to define a todo so you don't
forget to test a certain case.

```bash ./test todo.t
plan 1
todo "A todo."
```
```
1..1
not ok - # TODO A todo.
```

The `not_ok` function simply prints out not ok TAP line.

```bash ./test not_ok.bash || true
plan 1
not_ok "Is not ok."
```

Also notice that running the test file directly causes the process to exit with
a non zero code.

```bash bash
./t/not_ok.bash
echo $?
```
```
1..1
not ok - Is not ok.
1
```

Because we are using bash and working with exit codes, it is nice to have a few
helpers to make working with bash nicer.

```bash ./test success.t
plan 1
true; success "Previous command had a zero exit code."
```
```
1..1
ok - Previous command had a zero exit code.
```

```bash ./test failure.t
plan 1
false; failure "Previous command had a non zero exit code."
```
```
1..1
ok - Previous command had a non zero exit code.
```

Because the TAP output is written to stdout; we do not want to polute the
stdout with the output of other programs. In case you are interested in the
output we can use the `diagnostics` function. This will escape the output
according to TAP specifications.

```bash ./test diagnostics.t
plan 1
echo 'some random output from a command' | diagnostics
success "Previous command had a zero exit code."
```
```
1..1
# some random output from a command
ok - Previous command had a zero exit code.
```

Skip is great to make sure that the planned test count is still what we expect
yet it allows us to communicate that certain tests were not run.

```bash ./test skip.t
plan 2
skip "No need to test this."
ok "Is run and is ok."
```
```
1..2
ok - # skip No need to test this.
ok - Is run and is ok.
```

Certain cases we accept that a test does not continue but also doesn't cause
a test failure. We use `skip_all` for those cases. Make sure to not have defined any
other output. A `skip_all` is most likely to occur at the top of the file before
tests are run.


```bash ./test skip-all.t
skip_all "Because that was the intention."
```
```
1..0 # skip Because that was the intention.
```

Sometimes you want the complete test suite to fail when something happens.
For that we use `bail`.

To test this case we first write a bash-tap test that bails and then check if
that actually happens.

```bash tee ./t/bail.bash > /dev/null
#!/usr/bin/env bash

source bash-tap

plan 2
bail "Reason why it bailed." # Optionally you can exit here.
not_ok "Reaches this but ignores it."
```

> Bash-tap leaves it up to the user to exit on bail or not. This is to leave
> more freedom to the developer as to how and when the process should exit.

Now we test if this test fails when running it with prove test harness.

```bash ./test bail.t
plan 1
prove ./t/bail.bash 2>&1 | diagnostics
failure "Should bail."
```
```
1..1
# Bailout called.  Further testing stopped:  Reason why it bailed.
# FAILED--Further testing stopped: Reason why it bailed.
ok - Should bail.
```

This process will also exit with a non zero exit code.

```bash bash
bash ./t/bail.bash
echo $?
```
```
1..2
Bail out! Reason why it bailed.
not ok - Reaches this but ignores it.
1
```

When using pipes in bash, we have to make sure that if one of the processes in
that pipeline fails, the whole pipeline also returns a non zero exit code. We
use the `set -o pipefail` for that. bash-tap will do this for you when sourcing
it.

```bash ./test pipefail.t
plan 1
ls | xargs not-a-command 2>&1 | diagnostics
failure "Should fail because not-a-command is not an existant command."
```
```
1..1
# xargs: not-a-command: No such file or directory
ok - Should fail because not-a-command is not an existant command.
```

Besides bash you can also use bash-tap in dash. Dash does not have `source`
feature and therefore we have to `cat` to perform the tests. We'll run all
previously defined tests using dash.

```bash bash || true
source bash-tap

todo "Make sure only tests that dash can support are run. (hardcode?)"

for file in ./t/*.t; do
  {
    printf 'source() { return 0; }\n'
    cat bash-tap "$file"
  } | sh - > /dev/null
  success "Can run $file."
done

plan
```
```
not ok - # TODO Make sure only tests that dash can support are run. (hardcode?)
ok - Can run ./t/append-plan.t.
not ok - Can run ./t/bail.t.
ok - Can run ./t/diagnostics.t.
ok - Can run ./t/example.aliases.t.
ok - Can run ./t/example.append-plan.t.
not ok - Can run ./t/example.bail.t.
not ok - Can run ./t/example.not_ok_causes_failure.t.
ok - Can run ./t/example.ok.t.
not ok - Can run ./t/example.pipefail.t.
ok - Can run ./t/example.process.t.
ok - Can run ./t/example.skip-all.t.
ok - Can run ./t/example.skip.t.
ok - Can run ./t/example.todo.t.
ok - Can run ./t/failure.t.
ok - Can run ./t/ok.t.
not ok - Can run ./t/pipefail.t.
ok - Can run ./t/plan.t.
ok - Can run ./t/script-success.t.
ok - Can run ./t/skip-all.t.
ok - Can run ./t/skip.t.
ok - Can run ./t/source-using-path-variable.t.
ok - Can run ./t/source-using-relative-path.t.
ok - Can run ./t/success.t.
ok - Can run ./t/todo.t.
1..19
```

### Script Success

We might also only care if a complete script is run with success.

In that case simply  call the function script_success at the top of the file.

All stdout will by piped to diagnostics, the plan will be 1 and the rest of the
TAP output is either ok or not ok depending on the exit code of the running of
the script.

> Does require the file to be executable.

```bash ./test script-success.t
source bash-tap
script_success

echo hello world
```
```
1..1
# hello world
ok - Script ./t/script-success.t ran successfuly.
```

## Documentation

The ./README.md is generated using [Markatzea][markatzea].

```bash
markatzea README.mz > README.md
```

## Tests

Tests are located in prove's default ./t directory. This is how to run all of
them:

```bash bash
prove
```
```
t/append-plan.t .................... ok
t/bail.t ........................... ok
t/diagnostics.t .................... ok
t/example.aliases.t ................ ok
t/example.append-plan.t ............ ok
t/example.bail.t ................... ok
t/example.not_ok_causes_failure.t .. ok
t/example.ok.t ..................... ok
t/example.pipefail.t ............... ok
t/example.process.t ................ ok
t/example.skip-all.t ............... skipped: Because that was the intention.
t/example.skip.t ................... ok
t/example.todo.t ................... ok
t/failure.t ........................ ok
t/ok.t ............................. ok
t/pipefail.t ....................... ok
t/plan.t ........................... skipped: (no reason given)
t/script-success.t ................. ok
t/skip-all.t ....................... skipped: Because that was the intention.
t/skip.t ........................... ok
t/source-using-path-variable.t ..... ok
t/source-using-relative-path.t ..... ok
t/success.t ........................ ok
t/todo.t ........................... ok
All tests successful.
Files=24, Tests=30,  0 wallclock secs ( 0.04 usr  0.01 sys +  0.17 cusr  0.04 csys =  0.26 CPU)
Result: PASS
```

or to run one you can do the following.

```bash bash
prove ./t/ok.t
```
```
./t/ok.t .. ok
All tests successful.
Files=1, Tests=1,  0 wallclock secs ( 0.01 usr +  0.00 sys =  0.01 CPU)
Result: PASS
```

## License

GNU General Public License 3.0

[1]:https://github.com/bas080/bash-tap.wiki.git
[2]:https://github.com/bas080/markatzea
