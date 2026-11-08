# The hardware repository supplies this sibling toolchain submodule.
TOOLCHAIN ?= ../tools/atf15xx-yosys-docker
TOOLCHAIN := $(abspath $(TOOLCHAIN))
OUT ?= build/cupl

.PHONY: all jed-cupl main dma verify tool-versions
all: jed-cupl
jed-cupl: main dma

main:
	"$(TOOLCHAIN)/docker-run.sh" python3 scripts/build_canonical.py cupl QBUSEMUMAIN --output "$(OUT)"

dma:
	"$(TOOLCHAIN)/docker-run.sh" python3 scripts/build_canonical.py cupl QBUSEMUDMA --output "$(OUT)"

verify:
	"$(TOOLCHAIN)/docker-run.sh" python3 /opt/atf15xx/toolchain.py verify "$(OUT)/QBUSEMUMAIN/QBUSEMUMAIN.jed" "$(OUT)/QBUSEMUDMA/QBUSEMUDMA.jed"

tool-versions:
	"$(TOOLCHAIN)/docker-run.sh" python3 /opt/atf15xx/toolchain.py versions

VHDL_OUT ?= build/vhdl
.PHONY: jed-vhdl vhdl-main vhdl-dma compare-jed
jed-vhdl: vhdl-main vhdl-dma
vhdl-main:
	"$(TOOLCHAIN)/docker-run.sh" python3 scripts/build_canonical.py vhdl QBUSEMUMAIN --output "$(VHDL_OUT)"
vhdl-dma:
	"$(TOOLCHAIN)/docker-run.sh" python3 scripts/build_canonical.py vhdl QBUSEMUDMA --output "$(VHDL_OUT)"
compare-jed:
	"$(TOOLCHAIN)/docker-run.sh" python3 /opt/atf15xx/toolchain.py compare "$(OUT)/QBUSEMUMAIN/QBUSEMUMAIN.jed" "$(VHDL_OUT)/QBUSEMUMAIN/QBUSEMUMAIN.jed"
	cmp "$(OUT)/QBUSEMUMAIN/QBUSEMUMAIN.jed" "$(VHDL_OUT)/QBUSEMUMAIN/QBUSEMUMAIN.jed"
	cmp "$(OUT)/QBUSEMUMAIN/QBUSEMUMAIN.tt2" "$(VHDL_OUT)/QBUSEMUMAIN/QBUSEMUMAIN.tt2"
	"$(TOOLCHAIN)/docker-run.sh" python3 /opt/atf15xx/toolchain.py compare "$(OUT)/QBUSEMUDMA/QBUSEMUDMA.jed" "$(VHDL_OUT)/QBUSEMUDMA/QBUSEMUDMA.jed"
	cmp "$(OUT)/QBUSEMUDMA/QBUSEMUDMA.jed" "$(VHDL_OUT)/QBUSEMUDMA/QBUSEMUDMA.jed"
	cmp "$(OUT)/QBUSEMUDMA/QBUSEMUDMA.tt2" "$(VHDL_OUT)/QBUSEMUDMA/QBUSEMUDMA.tt2"
	@echo "Both designs: canonical netlists and JEDEC files are byte-identical."

.PHONY: check-equations
check-equations:
	"$(TOOLCHAIN)/docker-run.sh" python3 scripts/check_equations.py

.PHONY: test
test:
	python3 -m unittest discover -s tests -v

# SVF preparation and parser checks are offline. Hardware targets are explicit.
SVF_JED_DIR ?= $(VHDL_OUT)
SVF_OUT ?= build/svf
JTAG_BACKEND ?= docker
ifeq ($(JTAG_BACKEND),host)
JTAG_RUN := $(TOOLCHAIN)/jtag.sh
else ifeq ($(JTAG_BACKEND),docker)
JTAG_RUN := $(TOOLCHAIN)/jtag-in-docker.sh
else
$(error JTAG_BACKEND must be host or docker)
endif
JTAG_OPTIONS ?=

.PHONY: svf jtag-check jtag-scan program
svf:
	"$(TOOLCHAIN)/jtag-in-docker.sh" convert "$(SVF_JED_DIR)/QBUSEMUMAIN/QBUSEMUMAIN.jed" -d ATF1508AS -o "$(SVF_OUT)/QBUSEMUMAIN.svf"
	"$(TOOLCHAIN)/jtag-in-docker.sh" convert "$(SVF_JED_DIR)/QBUSEMUDMA/QBUSEMUDMA.jed" -d ATF1504AS -o "$(SVF_OUT)/QBUSEMUDMA.svf"

jtag-check:
	"$(TOOLCHAIN)/jtag-in-docker.sh" check --main "$(SVF_OUT)/QBUSEMUMAIN.svf" --dma "$(SVF_OUT)/QBUSEMUDMA.svf"

jtag-scan:
	"$(JTAG_RUN)" scan $(JTAG_OPTIONS)

program: svf
	"$(JTAG_RUN)" program --main "$(SVF_OUT)/QBUSEMUMAIN.svf" --dma "$(SVF_OUT)/QBUSEMUDMA.svf" $(JTAG_OPTIONS)
