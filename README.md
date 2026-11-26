# Álgebra Abstracta / Discretas III — cryptography exercises

C++ coursework from *Abstract Algebra* (Matemática Discreta III, UCSP, 2016):
classical ciphers, an Enigma simulator, and public-key cryptography (RSA,
ElGamal) built on [NTL](https://libntl.org/) big integers, together with the
number-theory helpers they need (Miller–Rabin, Fermat, Lucas–Lehmer, Pollard,
Gordon strong primes, sieve, and Blum-Blum-Shub / xorshift / Mersenne Twister /
LFSR generators). Folder names are the original ones; several folders are
successive versions of the same assignment.

| Program | Folder | What it does |
|---|---|---|
| `cesar` | `Cesar/` | Caesar cipher, interactive menu (1 encrypt, 2 decrypt, 0 quit) |
| `cesar1` | `Cesar.1/` | Variant on a different alphabet: reads key and word, prints cipher and round trip |
| `ruta` | `ruta/` | Route (grid transposition) cipher, pads with `x` |
| `vaya` | `vaya/` | Rail-fence ("valla") cipher |
| `control` | `Control/` | Rail fence + route + an extra substitution layer chained together (exam "control") |
| `protocolo2` | `Protocolo.2/` | Decrypts a hard-coded rail-fence + route ciphertext for a given key |
| `enigma` | `EnigmaSimulator/` | Three-rotor Enigma: encrypts and decrypts the alphabet twice |
| `rsa` | `RSA/` | RSA with random primes, CRT decryption; encrypt with any `n e`, decrypt with its own key |
| `elgamal` | `GAMAL/` | ElGamal: generates `e1 e2 p`, encrypts `Mensaje.txt`, decrypts |

Not built by default, kept as they are:

- `AFIN/` affine cipher — compiles (`make build/afin`) but its constructor loops forever.
- `FDigital/` digital signature and `Protocolo/` full protocol — unfinished drafts, do not compile.
- `Protocolo.2/main.cc` — older draft of `main2.cc`.
- `Alogrithms/`, `RandLFSR/`, `Practica/` — fragments with no or an empty `main`.
- `Documentos/` — course slides (classical cryptography, RSA).

## Build

Requires `g++` and `make`; `rsa` and `elgamal` also need NTL and GMP.

```bash
sudo apt install libntl-dev libgmp-dev   # Debian/Ubuntu
make                                      # everything into build/
make classic                              # only the programs without NTL
make NTL_PREFIX=$HOME/opt/ntl             # NTL installed somewhere else
```

## Run (real output)

```bash
$ echo 4 holamundo | build/ruta
oxxxdalohmun
holamundoxxx

$ echo 3 holamundo | build/vaya
holamundo
hmoxoaudxxlnx
holamundoxxxx

$ build/enigma
JDFXUEZVUNPJRDZHPZTORQVYINJDFXUEZVUNPJRDZHPZTORQVYIN
ABCDEFGHUNPLMNOPQRSTUVWXYZABCDEFGHUNPLMNOPQRSTUVWXYZ
```

`rsa` and `elgamal` read and write data files (`diccionario.txt`,
`Mensaje.txt`, `Datos.txt`, `Guardar.txt`, `encriptado.txt`) in the current
directory, so run them from their folder — or from a copy of it, since they
overwrite the files that are committed:

```bash
cd RSA && ../build/rsa      # prints p, q, n, e, d; then 1 = encrypt (n e message), 2 = decrypt, 0 = quit
cd GAMAL && ../build/elgamal  # prints e1, e2, p; then 1 = encrypt Mensaje.txt (e1 e2 p), 2 = decrypt
```

A scripted round trip with the generated keys gave `holamundo` → cipher →
`holamundoAAAAAAAAAA` for RSA and `Wilber Cutire Sivincha` →
`Wilber Cutire SivinchaAAAAAAAAAAAAAAAA` for ElGamal (the `A`s are block padding).

## Known issues

- `enigma` does not decrypt `I`, `J`, `K` back correctly (see the output above).
- `control` encrypts, but decrypting its own output did not give the plaintext back.
- `protocolo2` output does not look like plaintext for the keys tried.
