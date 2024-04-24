VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
# ARCHITECTURE=microcontroler_arch
ARCHITECTURE=microcontroler_test
vhd_files=./microcontroler_test.vhd $(filter-out $(wildcard ../*/*_test.vhd), $(wildcard ../*/*.vhd))

.PHONY: all
all: work elaborate run

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

elaborate:
	$(VHDL) -e $(VHDLFLAGS) $(ARCHITECTURE)

run:
	$(VHDL) -r $(VHDLFLAGS) $(ARCHITECTURE) --wave=res_out.ghw

