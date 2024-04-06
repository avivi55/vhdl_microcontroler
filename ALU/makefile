VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
ARCHITECTURE=alu_test

vhd_files=$(wildcard *.vhd)

.PHONY: all

all: work elaborate run

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

elaborate:
	$(VHDL) -e $(VHDLFLAGS) $(ARCHITECTURE)

run:
	$(VHDL) -r $(VHDLFLAGS) $(ARCHITECTURE) --wave=res.ghw
