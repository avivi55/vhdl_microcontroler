VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08

vhd_files=$(wildcard *.vhd)

.PHONY: all

all: work elaborate run

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

elaborate:
	$(VHDL) -e $(VHDLFLAGS) instructions_buf_test

run:
	$(VHDL) -r $(VHDLFLAGS) instructions_buf_test --wave=res_out.ghw

