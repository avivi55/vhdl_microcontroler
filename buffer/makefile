VHDL=ghdl
VHDLFLAGS=-fexplicit --ieee=synopsys --std=08
ARCHITECTURE=buffer_wave
TEST=buffer_test

vhd_files=$(wildcard *.vhd) 

.PHONY: all

all: work test wave clean

work:
	$(VHDL) -a -g $(VHDLFLAGS) $(vhd_files)

test:
	@echo "================================TEST================================"
	$(VHDL) --elab-run $(VHDLFLAGS) $(TEST) 
	@echo "================================TEST================================"

wave:
	@echo "--------------------------------WAVE--------------------------------"
	$(VHDL) --elab-run $(VHDLFLAGS) $(ARCHITECTURE) --wave=waves/wave.ghw
	@echo "--------------------------------WAVE--------------------------------"

clean:
	rm *.cf

