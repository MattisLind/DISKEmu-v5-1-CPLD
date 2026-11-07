# Building the Q-bus CPLDs from CUPL or VHDL

Both source paths produce **byte-identical JEDEC files** for each device. They
share a canonical Boolean netlist backend and the same pinned Atmel fitters:

```text
PLD  -> CUPL compiler -> TT2 ---\
                               canonical TT2 -> fit1508/fit1504 -> JEDEC
VHDL -> GHDL/Yosys -> JSON ----/
```

The VHDL path does not read the PLD files, CUPL netlists or reference JEDEC files,
and does not invoke the CUPL compiler. The two languages share only the board
contract in `qbus-pinout.json`, Boolean canonicalizer, and fitter.

## Commands

From the parent DISKEmu hardware repository, with Docker running:

```sh
git submodule update --init --recursive
make toolchain
make -j4 jed-cupl jed-vhdl
make compare-jed
make check-equations
make cpld-test
```

From this CPLD directory use `make jed-cupl`, `make jed-vhdl`, `make compare-jed`,
`make check-equations` and `make test`. A standalone checkout can set
`TOOLCHAIN=/absolute/path/to/atf15xx-yosys-docker` when invoking make.

| Design | Device | Original CUPL | VHDL |
| --- | --- | --- | --- |
| MAIN | ATF1508AS-10AU100 | `QBUSEMUMAIN.PLD` | `QBUSEMUMAIN.vhdl` |
| DMA | ATF1504AS-10AU44 | `QBUSEMUDMA.PLD` | `QBUSEMUDMA.vhdl` |

Outputs for each language are separate:

```text
build/cupl/QBUSEMUMAIN/QBUSEMUMAIN.jed
build/cupl/QBUSEMUDMA/QBUSEMUDMA.jed
build/vhdl/QBUSEMUMAIN/QBUSEMUMAIN.jed
build/vhdl/QBUSEMUDMA/QBUSEMUDMA.jed
```

`make main` / `make dma` build individual CUPL devices; `make vhdl-main` /
`make vhdl-dma` build individual VHDL devices. Every invocation rebuilds in a
fresh working directory. Generated files and downloads are ignored by Git.
The targets cover the real Q-bus variant; the `DISKEMU*.PLD` DIN41612/QBUS64
variant is unchanged and has not been translated.

## Why a common backend is necessary

Independent CUPL and GHDL/Yosys-to-EDIF synthesis can choose different gate
factoring, product terms, macrocell placement and unused-register elimination.
Their native fitter outputs were not identical. The EDIF fitter also crashed
when retaining the DMA design's otherwise unused synchronizer registers.

Both production build paths now use reduced ordered binary decision diagrams
(BDDs) to represent each Boolean function, followed by a deterministic
prime-implicant cover. The result is written in the fitter's CUPL TT2 format.
The same function, register kind, clock, controls and pin contract therefore
produce the same netlist independently of frontend gate order or factoring.
A serialization/parse round trip must reproduce the canonical TT2 exactly.

This changes the **PLD build backend too**. The matched files are not promised
to match the previous direct WinCUPL-to-fitter images. The original source logic
is unchanged, and raw CUPL netlists are retained as an independent reference.
The common backend is actual compilation; it does not copy a reference JEDEC
or substitute CUPL logic into the VHDL build.

The fitter's `Created on:` header is replaced by a stable header and its JEDEC
transmission checksum is recalculated. Fuse records and their checksum are
untouched; the file is validated before and after normalization. This removes
wall-clock differences while retaining valid programming checksums.

`make compare-jed` validates both fuse maps, then uses `cmp` to require exact
byte equality of both JEDEC files and both canonical TT2 netlists. It fails on
any difference. Editing one language alone is expected to fail this comparison
when the implementation changes.

## Translation and checks

The VHDL files preserve CUPL's expanded equations and state encoding, including
the compiled behavior of unspecified DMA states. They instantiate explicit
native D/T flip-flop primitives so synthesis retains clock enables, asynchronous
preset/reset and even unused registers. Each file includes simulation models
under `synthesis translate_off`; GHDL synthesis uses the vendor primitives.
The Boolean frontend currently supports the structural style used by these two
files; unsupported cell types fail explicitly.

Important preserved details include:

- The address counter clocks on the falling edge of `TSACK`.
- Address/direction registers use asynchronous loading; this is not converted
  to master-clocked logic.
- DMA request uses the `DMR` edge; bus registers use their original individual
  clock signals.
- The physical `INTQ` pin is the inverse of its logical register.
- Synchronizer stages and the constant-D DMA6 register remain explicit.
- Four DMA state observation outputs retain their original automatic pin
  assignment; all 94 explicitly assigned pins across the two devices are fixed.

`make check-equations` elaborates the actual VHDL with GHDL and compares it with
raw, independently compiled CUPL TT2. Native register outputs become symbolic
state inputs. Yosys SAT proves all **353** next-state, clock, enable,
asynchronous-control, combinational and OE equations for all Boolean inputs
and corresponding arbitrary register states. It also checks registered output
polarity. A deliberately changed output equation was tested and rejected.
This is an equation/state-transition check, not a physical timing or metastability
proof. The matching JEDEC comparisons separately verify the final programming
images between the two production source paths.

`make test` exhaustively checks canonical covers for all 256 three-input Boolean
functions, gate-factoring independence and detection of different functions.
The toolchain's own tests cover damaged checksums, pin changes and deterministic
JEDEC header normalization.

Each output directory contains:

- `.tt2`: canonical netlist supplied to the fitter.
- `.fit`, `.pin`, `.fitter.log`: resource report, final pin assignments and log.
- `.build.json`: fitter/tool identities, canonical input hash and fuse digest.
- `.frontend.json`: source/contract hashes and canonicalization statistics.
- CUPL `.frontend.tt2` and associated listings, or VHDL `.rtl.json` and GHDL log.

Builds check device/package, 10 ns speed grade, fixed pins, JTAG ON, security OFF,
fuse count and JEDEC checksums. A failed build removes the previous programming
file and manifests for that design. Successful fitting does not establish
physical timing closure or replace hardware testing.
