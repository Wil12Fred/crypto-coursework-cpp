#!/bin/sh
# Golden tests: run each program on tests/golden/<case>.in and compare its
# stdout with tests/golden/<case>.out.  The program is the case name up to
# the first '-' (control-decrypt.in runs build/control).
set -u
cd "$(dirname "$0")/.."
fail=0; n=0
for in in tests/golden/*.in; do
  case=$(basename "$in" .in)
  prog=build/${case%%-*}
  n=$((n + 1))
  if "$prog" < "$in" | cmp -s - "tests/golden/$case.out"; then
    echo "ok   $case"
  else
    echo "FAIL $case"; fail=$((fail + 1))
    "$prog" < "$in" | diff "tests/golden/$case.out" - | head -20
  fi
done
echo "golden: $n cases, $fail failures"
[ "$fail" -eq 0 ]
