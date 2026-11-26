#!/usr/bin/env bash
# Round trips for the NTL programs (rsa, elgamal).  Their keys are random on
# every run, so the test drives one interactive session: read the public key
# the program just generated, encrypt with it, feed the ciphertext back and
# check the plaintext returns.  Both pad the last block, which decrypts as
# trailing 'A's (index 0 of the alphabet); only that padding is tolerated.
# Each program runs in a scratch copy of its folder because it overwrites
# the data files there.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
fail=0

# wait_for <file> <pattern> <count>: until <pattern> occurs <count> times.
wait_for() {
  for _ in $(seq 1 600); do
    [ "$(grep -c -- "$2" "$1" 2>/dev/null || true)" -ge "$3" ] && return 0
    sleep 0.1
  done
  echo "timeout waiting for '$2' x$3 in $1"; cat "$1"; return 1
}

# line_before <file> <pattern> <n>: the line before the n-th <pattern>.
line_before() {
  awk -v p="$2" -v n="$3" '$0 ~ p { c++; if (c == n) { print prev; exit } } { prev = $0 }' "$1"
}

check() {  # check <name> <want> <got>
  local rest=${3#"$2"}
  if [ "${3:0:${#2}}" = "$2" ] && [ -z "${rest//A/}" ]; then
    echo "ok   $1: '$2' -> ... -> '$3'"
  else
    echo "FAIL $1: want '$2' (+ 'A' padding), got '$3'"; fail=1
  fi
}

session() {  # session <folder> <binary>: sets $dir, $out, $in (fd 3 = stdin)
  dir=$(mktemp -d); cp -r "$root/$1/." "$dir/"
  out=$dir/stdout; mkfifo "$dir/stdin"
  (cd "$dir" && exec "$root/build/$2" < stdin > stdout 2>&1) &
  pid=$!
  exec 3> "$dir/stdin"
}
finish() { echo 0 >&3 || true; exec 3>&-; wait "$pid" || true; rm -rf "$dir"; }

# RSA: the public key is written to Datos.txt as "n: <n>" / "e: <e>".
session RSA rsa
wait_for "$out" '^Encriptar-Desencriptar' 1
n=$(sed -n 's/^n: //p' "$dir/Datos.txt"); e=$(sed -n 's/^e: //p' "$dir/Datos.txt")
msg=holamundoHOLAMUNDO1234567890
printf '1\n%s %s %s\n' "$n" "$e" "$msg" >&3
wait_for "$out" '^Encriptar-Desencriptar' 2
cipher=$(line_before "$out" '^Encriptar-Desencriptar' 2)
printf '2\n%s\n' "$cipher" >&3
wait_for "$out" '^Encriptar-Desencriptar' 3
check rsa "$msg" "$(line_before "$out" '^Encriptar-Desencriptar' 3)"
finish

# ElGamal: prints e1, e2, p on its first three lines, encrypts Mensaje.txt.
session GAMAL elgamal
wait_for "$out" '^encriptar-desencriptar' 1
mapfile -t key < <(head -3 "$out")
msg=$(cat "$dir/Mensaje.txt")
printf '1\n%s %s %s\n' "${key[0]}" "${key[1]}" "${key[2]}" >&3
wait_for "$out" '^encriptar-desencriptar' 2
cipher=$(line_before "$out" '^encriptar-desencriptar' 2)
printf '2\n%s\n' "$cipher" >&3
wait_for "$out" '^encriptar-desencriptar' 3
check elgamal "$msg" "$(line_before "$out" '^encriptar-desencriptar' 3)"
finish

exit $fail
