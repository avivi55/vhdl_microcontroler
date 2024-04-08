VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
ARCHITECTURE=microcontroller
vhd_files=$(wildcard *.vhd) $(filter-out $(wildcard */*_test.vhd), $(wildcard */*.vhd))

.PHONY: all

all: work #elaborate run

work:
	@echo $(vhd_files)
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

elaborate:
	$(VHDL) -e $(VHDLFLAGS) $(ARCHITECTURE)

run:
	$(VHDL) -r $(VHDLFLAGS) $(ARCHITECTURE) --wave=res_out.ghw

