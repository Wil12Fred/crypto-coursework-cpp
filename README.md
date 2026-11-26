# crypto-coursework-cpp

[![CI](https://github.com/Wil12Fred/crypto-coursework-cpp/actions/workflows/ci.yml/badge.svg)](https://github.com/Wil12Fred/crypto-coursework-cpp/actions/workflows/ci.yml) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

C++ cryptography coursework: classical ciphers, a three-rotor Enigma simulator,
and RSA and ElGamal written from scratch on top of NTL big integers, with the
number-theory helpers they need. Every cipher is tested by encrypting and
decrypting back.

## Features

- Caesar (`cesar`) and a reflected Caesar variant (`cesar1`).
- Affine cipher (`afin`), key chosen at random and coprime with the alphabet.
- Route (spiral grid) transposition (`ruta`) and rail fence (`vaya`), padding with `x`.
- `control`: rail fence, then route, then an affine layer whose `(a, b)` is
  derived from a key string.
- Three-rotor Enigma with reflector B (`enigma`); encrypting twice gives the
  plaintext back.
- RSA (`rsa`): 128-bit modulus from random primes, decryption by the Chinese
  remainder theorem.
- ElGamal (`elgamal`): 512-bit prime, generates `e1 e2 p`, encrypts `Mensaje.txt`.
- Helpers in `RSA/` and `GAMAL/`: Miller–Rabin, Fermat, Lucas–Lehmer, Pollard
  rho, Gordon strong primes, sieve of Eratosthenes, Blum-Blum-Shub, xorshift,
  Mersenne Twister and LFSR generators.

## Requirements

- `g++` (C++17) and `make` for everything except RSA/ElGamal.
- RSA and ElGamal also need NTL and GMP:
  - Debian/Ubuntu: `sudo apt install g++ make libntl-dev libgmp-dev`
  - Arch: `sudo pacman -S gcc make gmp`, plus `ntl` from the AUR

## Build

```bash
make                           # every program into build/
make classic                   # only the programs that do not need NTL
make NTL_PREFIX=$HOME/opt/ntl  # NTL installed somewhere else
make clean
```

## Run

Real output of the built programs:

```text
$ echo 4 holamundo | build/ruta          # key, message
oxxxdalohmun
holamundoxxx

$ echo 3 holamundo | build/vaya
holamundo
hmoxoaudxxlnx
holamundoxxxx

$ echo 3 holamundo | build/cesar1
zsvcumt-s
holamundo

$ build/afin                             # decrypt(encrypt(alphabet))
abcdefghijklmnopqrstuvwxyz

$ build/enigma                           # alphabet twice, encrypted, then decrypted
JDFXUEZVUNPJRDZHPZTORQVYINJDFXUEZVUNPJRDZHPZTORQVYIN
ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ
```

`control` encrypts a fixed message with a key (a string and a number). To
decrypt, give the same key, then the ciphertext on its own line (it may
contain spaces), then the length it printed (menu lines elided):

```text
$ printf '1\nWilberCutire 5\n' | build/control
27 500
...
a - b
30 166
49
tdfdihdW WtWfy RdfW   diddRiWtttfiRRdidhdhhhfyRyyy

$ printf '2\nWilberCutire 5\ntdfdihdW WtWfy RdfW   diddRiWtttfiRRdidhdhhhfyRyyy\n49\n' | build/control
27 500
...
a - b
30 166
holamundoholamundoholamundoholamundoholamundoxxxx
```

`cesar` is an interactive menu (key, then `1` encrypt / `2` decrypt / `0` quit).

`rsa` and `elgamal` read and write data files (`diccionario.txt`,
`Mensaje.txt`, `Datos.txt`, `Guardar.txt`, `encriptado.txt`) in the current
directory, so run them from their folder, or from a copy of it, since they
overwrite the committed files. Keys are new on every run.

```bash
cd RSA && ../build/rsa        # prints p, q, n, e, d; then 1 = encrypt (n e message), 2 = decrypt, 0 = quit
cd GAMAL && ../build/elgamal  # prints e1, e2, p; then 1 = encrypt Mensaje.txt (e1 e2 p), 2 = decrypt
```

A round trip as run by `make test` on GitHub Actions:

```text
ok   rsa: 'holamundoHOLAMUNDO1234567890' -> ... -> 'holamundoHOLAMUNDO1234567890AAAAAAAAA'
ok   elgamal: 'Wilber Cutire Sivincha' -> ... -> 'Wilber Cutire SivinchaAAAAAAAAAAAAAAAA'
```

## Tests

```bash
make test          # everything (needs NTL)
make test-classic  # unit + golden tests, g++ only
make test-bignum   # RSA and ElGamal session round trips, needs NTL
```

- `tests/unit/`: round trips `decrypt(encrypt(m)) == m` for Caesar and its
  variant (every key), affine (200 random keys, plus the modular inverse),
  route and rail fence (keys 2–9, lengths 1–60, only `x` padding allowed),
  the `control` pipeline (several key strings and sizes), and Enigma
  (`enc(enc(m)) == m` over every rotor offset, no letter maps to itself).
- `tests/golden/`: each program run on `<case>.in` and compared with
  `<case>.out`, including `control` decrypting its own output and Caesar
  round-tripping `X`.
- `tests/bignum_roundtrip.sh`: starts `rsa` / `elgamal` in a scratch copy of
  their folder, reads the key they just generated, encrypts, feeds the
  ciphertext back and checks the plaintext returns, followed only by the `A`
  block padding.

CI also checks that the `FDigital/` and `Protocolo/` drafts still fail to
compile, and warns if one starts compiling.

## Project layout

```text
Cesar/  Cesar.1/        Caesar and reflected-Caesar variant
AFIN/                   affine cipher (uses Control/mate.h)
ruta/  vaya/            route and rail-fence transpositions
Control/                rail fence + route + affine, keyed by a string
EnigmaSimulator/        three-rotor Enigma
RSA/  GAMAL/            RSA and ElGamal on NTL, with number-theory helpers
Protocolo.2/            decrypts a hard-coded rail fence + route ciphertext
FDigital/  Protocolo/   unfinished drafts (digital signature, full protocol)
Alogrithms/ RandLFSR/ Practica/   fragments, not built
Documentos/             course slides
tests/                  unit, golden and NTL round-trip tests
```

## Known limitations

- `FDigital/` does not compile: it includes `rsa.h`, which was never committed
  to that folder. `Protocolo/` does not compile either (`fdigital.h` compares an
  `int` with a `string`). Both are left out of the build.
- `Protocolo.2/main.cc` is an older draft that includes headers that do not
  exist; only `main2.cc` is built. Its output does not look like plaintext for
  the keys tried, and the intended key is not known.
- `Alogrithms/`, `RandLFSR/` and `Practica/` are fragments (an empty `main`,
  a method with no class, string exercises) and are not built.
- RSA and ElGamal pad the last block with zeros, which decrypt as trailing `A`s.
  RSA keys are only 128 bits: an exercise, not secure.
- Programs read words with `cin >>`, so `cesar` and `rsa` messages cannot
  contain spaces, and `cesar` can emit a newline as ciphertext (its alphabet
  ends in `\n`).
- `control` always encrypts the same hard-coded message; the key only changes
  how it is encrypted.
- `rsa` and `elgamal` overwrite their committed data files when run.

## Background

Coursework for an abstract algebra / discrete mathematics course at a
university, 2016. Folder names and identifiers are the original Spanish ones;
several folders are successive versions of the same assignment.
`Documentos/` holds the course slides on classical cryptography and RSA.

## License

MIT — see [LICENSE](LICENSE).
