CXX      ?= g++
CXXFLAGS ?= -std=c++17 -O2
BUILD    := build

# RSA and ElGamal use NTL (big integers) on top of GMP.
# System install: apt install libntl-dev.  Elsewhere: make NTL_PREFIX=/path/to/ntl
NTL_PREFIX ?=
NTL_CFLAGS := $(if $(NTL_PREFIX),-I$(NTL_PREFIX)/include)
NTL_LIBS   := $(if $(NTL_PREFIX),-L$(NTL_PREFIX)/lib) -lntl -lgmp -pthread

CLASSIC := afin cesar cesar1 control enigma ruta vaya protocolo2
BIGNUM  := rsa elgamal

.PHONY: all classic bignum test test-classic test-bignum clean
all: classic bignum
classic: $(addprefix $(BUILD)/,$(CLASSIC))
bignum:  $(addprefix $(BUILD)/,$(BIGNUM))

$(BUILD):
	mkdir -p $@

# AFIN/afin.h needs gcd() and inv(); the only mate.h that defines them is Control's.
$(BUILD)/afin: AFIN/main.cc AFIN/afin.h Control/mate.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -IControl -o $@ $<
$(BUILD)/cesar: Cesar/main.cc $(wildcard Cesar/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<
$(BUILD)/cesar1: Cesar.1/main.cc $(wildcard Cesar.1/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<
$(BUILD)/control: Control/main.cc $(wildcard Control/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<
$(BUILD)/enigma: EnigmaSimulator/enigma.cc | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<
$(BUILD)/ruta: ruta/main.cc ruta/ruta.h | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<
$(BUILD)/vaya: vaya/main.cc $(wildcard vaya/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<
$(BUILD)/protocolo2: Protocolo.2/main2.cc $(wildcard Protocolo.2/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) -o $@ $<

$(BUILD)/rsa: RSA/main.cc $(wildcard RSA/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) $(NTL_CFLAGS) -o $@ $< $(NTL_LIBS)
$(BUILD)/elgamal: GAMAL/main.cc $(wildcard GAMAL/*.h) | $(BUILD)
	$(CXX) $(CXXFLAGS) $(NTL_CFLAGS) -o $@ $< $(NTL_LIBS)

# Tests.  `make test-classic` needs only g++; `make test-bignum` needs NTL.
UNIT := cesar cesar1 transposition afin enigma control
UNIT_BINS := $(addprefix $(BUILD)/tests/test_,$(UNIT))

$(BUILD)/tests:
	mkdir -p $@
$(BUILD)/tests/test_%: tests/unit/test_%.cc tests/unit/check.h | $(BUILD)/tests
	$(CXX) $(CXXFLAGS) -o $@ $<

test: test-classic test-bignum
test-classic: classic $(UNIT_BINS)
	@for t in $(UNIT_BINS); do $$t > $$t.log || { cat $$t.log; exit 1; }; tail -1 $$t.log; done
	tests/run_golden.sh
test-bignum: bignum
	tests/bignum_roundtrip.sh

clean:
	rm -rf $(BUILD)
