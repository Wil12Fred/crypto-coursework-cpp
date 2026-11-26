CXX      ?= g++
CXXFLAGS ?= -std=c++17 -O2
BUILD    := build

# RSA and ElGamal use NTL (big integers) on top of GMP.
# System install: apt install libntl-dev.  Elsewhere: make NTL_PREFIX=/path/to/ntl
NTL_PREFIX ?=
NTL_CFLAGS := $(if $(NTL_PREFIX),-I$(NTL_PREFIX)/include)
NTL_LIBS   := $(if $(NTL_PREFIX),-L$(NTL_PREFIX)/lib) -lntl -lgmp -pthread

CLASSIC := cesar cesar1 control enigma ruta vaya protocolo2
BIGNUM  := rsa elgamal

.PHONY: all classic bignum clean
all: classic bignum
classic: $(addprefix $(BUILD)/,$(CLASSIC))
bignum:  $(addprefix $(BUILD)/,$(BIGNUM))

$(BUILD):
	mkdir -p $@

# Not in `all`: the affine-cipher draft compiles but its constructor never returns.
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

clean:
	rm -rf $(BUILD)
